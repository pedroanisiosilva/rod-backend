require 'open-uri'


class WeekStatusController < ApplicationController
  skip_authorize_resource :only => [:image,:daily]
  load_and_authorize_resource :class => "Membership"
  layout false, except: [:index]
  include ApplicationHelper

def daily
  # User.joins(:membership).where("group_id = ? and datetime > ? and user_id IS NOT NULL",1, begin_datetime).distinct 
  # User.distinct(:id).joins(:groups, :runs).where("group_id = ? and datetime > ?",1, begin_datetime)
  # User.select("count(distinct users.id) as users, count(runs.id)").joins(:groups, :runs).where("group_id = ? and datetime > ?",1, begin_datetime).to_a.first.users

  begin_date      = Date.parse(Time.zone.now.beginning_of_week.to_s)
  begin_datetime  = Time.zone.now.beginning_of_week.utc.to_s  
  @group_users_id = Membership.select(:user_id).where(:group_id => params[:group_id])
  @active_runners = User.where(:id => @group_users_id).joins(:runs).where("datetime > ? and user_id IS NOT NULL", begin_datetime).distinct 
  w               = WeeklyGoal.where(:first_day => begin_date, :user=>User.where(:id => @group_users_id))
  u               = User.where(:status =>0, :id=> @group_users_id)  
  @meta           = w.map{|m|m.distance.to_f}.reduce(:+)
  @real           = u.map{|m|m.weekly_runs_km}.reduce(:+)
  @run_count      = u.map{|m|m.weekly_runs_count}.reduce(:+)

  if @meta.nil? || @meta == 0
    @meta = 0
  end 
  if @real.nil? || @real == 0
    @real             = 0
    @percent          = 0
    @percent_string   = 0
  else
     @percent         = @real/@meta
     @percent_string  = %{#{(@percent*100).round(0)}%}
  end  

  @real           = @real.to_i
  @meta           = @meta.to_i

end

def image

  css_url = Array.new
  js_url  = Array.new

  ##don't use minified js or CSS urls

  css_url.push('http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css')
  js_url.push('https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.js')
  js_url.push('http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.js')

  output = render_to_string(:action => "#{self.daily}", :format =>[:html], :layout => false,
    :template => "week_status/daily.html.erb", :locals => {:imgkit => "true"})

  # IMGKit.new takes the HTML and any options for wkhtmltoimage
  # run `wkhtmltoimage --extended-help` for a full list of options
  kit = IMGKit.new(output, :quality => 90, :'crop-w' => 450, :'crop-x' => 10, :'crop-y' => 10, :'crop-h' => 190,:custom_header => ['IMGKit', "yes"])
  #kit = IMGKit.new(output, :quality => 90,:custom_header => ['IMGKit', "yes"])

  css_url.each do |url|
    kit.stylesheets << open(url)
  end

  js_url.each do |url|
    kit.javascripts << open(url)
  end

  @img = kit.to_img(:png)
    respond_to do |format|
      format.png {send_data @img}
    end  
end

def index

	categories = Hash.new
	categories = {"Extreme Black" => "+450km", "Extreme Red" => "+350km", "Black" => "+250km",
        "Red" => "+200km","Purple" => "+150km","Blue" => "+100km", "Green" => "+75km",
        "Orange" => "+50km", "Yellow" => "+25km", "White" => "0-24km"}

  # Group Selection #
  @result = Hash.new
  @group_users_id = Membership.accessible_by(current_ability).select(:user_id).where(:group_id => params[:group_id])
  ###################
 

  if params[:week_number].nil?
    week = Time.zone.now.at_beginning_of_week.strftime("%W").to_i
  else
    week = params[:week_number].to_i
  end

  range_date = Date.commercial(Time.zone.now.year.to_i, week)

  if range_date.beginning_of_week.month != range_date.end_of_week.month
    filter_date = Date.parse(Time.zone.now.to_s)
  else
    filter_date = range_date
  end

  nan_speed = 1000000

    if params[:belt]
      speed_hash = Hash.new

    	belt = params[:belt].capitalize
			runners =  User.where(:id => @group_users_id).group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", belt, filter_date.at_beginning_of_month])
			self.delete_from_relation_if_no_goal(runners,range_date)

      runners.each do |runner|
        total_distance = runner.weekly_runs_km_on_date(range_date)
        total_duration = runner.weekly_runs_duration_on_date(range_date)
        speed = total_duration/total_distance
        if speed.nan?
          nan_speed=nan_speed+0.01
          speed = nan_speed
        end
        speed_hash[speed] = runner
      end

      @result[belt] = Hash[speed_hash.sort].values

    else

		  categories.each do |key, value|
        speed_hash = Hash.new


  			runners = User.where(:id => @group_users_id).group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", key, filter_date.at_beginning_of_month])
  			self.delete_from_relation_if_no_goal(runners,range_date)

        runners.each do |runner|
          total_distance = runner.weekly_runs_km_on_date(range_date)
          total_duration = runner.weekly_runs_duration_on_date(range_date)
          speed = total_duration/total_distance
        if speed.nan?
          nan_speed=nan_speed+0.01
          speed = nan_speed
        end
          speed_hash[speed] = runner
        end

  			@result[key] = Hash[speed_hash.sort].values

		  end    	
    end
  end

  def delete_from_relation_if_no_goal (runners,date)
    runners.to_a.delete_if {|runner| runner.weekly_goal_on_date(date).nil?}
  end

end