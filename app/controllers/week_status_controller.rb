require 'open-uri'


class WeekStatusController < ApplicationController
  layout false, except: [:index]
  include ApplicationHelper

def daily

  begin_date      = Date.today.beginning_of_week
  @active_runners  = User.joins(:runs).where("datetime > ? and user_id IS NOT NULL", begin_date).distinct 
  w               = WeeklyGoal.where(:first_day => begin_date)
  @meta            = w.map{|m|m.distance.to_f}.reduce(:+)
  u               = User.where(:status =>0)
  @real            = u.map{|m|m.weekly_runs_km}.reduce(:+)
  @run_count       = u.map{|m|m.weekly_runs_count}.reduce(:+)
  @percent         = @real/@meta
  @percent_string  = %{#{(@percent*100).round(0)}%}

  @real = @real.to_i
  @meta = @meta.to_i

end

def image
  url2  = view_context.asset_url('css/pro-bars.min.css')
  css2  = open(url2)

  output = render_to_string(:action => "#{self.daily}", :format =>[:html], :layout => false,
    :template => "week_status/daily.html.erb", :locals => {:imgkit => "true"})

  # IMGKit.new takes the HTML and any options for wkhtmltoimage
  # run `wkhtmltoimage --extended-help` for a full list of options
  kit = IMGKit.new(output, :quality => 90, :'crop-w' => 452, :'crop-x' => 18, :'crop-y' => 10, :'crop-h' => 192,:custom_header => ['IMGKit', "yes"])
  #kit = IMGKit.new(output, :quality => 90,:custom_header => ['IMGKit', "yes"])

  # kit.stylesheets << '/path/to/css/file'
  # kit.javascripts << '/path/to/js/file'
  kit.stylesheets << css2


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

  @result = Hash.new

  if params[:week_number].nil?
    week = Time.zone.now.at_beginning_of_week.strftime("%W").to_i
  else
    week = params[:week_number].to_i
  end

  range_date = Date.commercial(Time.zone.now.year.to_i, week)

  if range_date.beginning_of_week.month != range_date.end_of_week.month
    filter_date = Time.zone.now
  else
    filter_date = range_date
  end

  nan_speed = 1000000

    if params[:belt]
      speed_hash = Hash.new

    	belt = params[:belt].capitalize
			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", belt, filter_date.at_beginning_of_month])
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


  			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", key, filter_date.at_beginning_of_month])
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