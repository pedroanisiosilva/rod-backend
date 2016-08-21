class User < ActiveRecord::Base
	acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	enum status: [:active, :inactive, :failed, :injured, :quitted]
	belongs_to :role
	has_many :runs, -> { order(datetime: :desc) }
	has_many :categories
	has_many :weekly_goals
	has_many :memberships
	has_many :groups, :through => :memberships
	validates_presence_of :email, :time_zone
	after_create :create_category_and_initial_goal
	before_create :set_default_role
	after_initialize :set_default_role
	before_validation :set_default_time_zone
	before_update :log_status_change, :if => :status_changed?

  ROLES = %w[admin moderator author banned].freeze

  	def log_status_change

		case self.status when "injured"
			Activity.create(:user_id => self.id, :event_type=>'user_injured', :is_public=>false)
		when "active"
			Activity.create(:user_id => self.id, :event_type=>'user_active', :is_public=>false)
		when "inactive"
			Activity.create(:user_id => self.id, :event_type=>'user_inactive', :is_public=>false)
		when "failed"
			Activity.create(:user_id => self.id, :event_type=>'user_failed', :is_public=>false)			
		when "quitted"
			Activity.create(:user_id => self.id, :event_type=>'user_quitted', :is_public=>false)			
		end
  	end

	def category
		self.category_on_date(Time.zone.now)
	end

	def category_on_date(date)
		self.categories.find_by(:first_day => date.at_beginning_of_month)
	end

	def weekly_goal
		self.weekly_goal_on_date(Time.zone.now)
	end

	def weekly_goal_on_date(date)
		time_obj = Date.parse(Time.parse(date.to_s).strftime('%Y/%m/%d'))
		self.weekly_goals.find_by(:first_day => time_obj.beginning_of_week)
	end

	def weekly_runs_km
		self.weekly_runs_km_on_date(Time.zone.now)
	end

	def weekly_runs_km_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).sum(:distance).to_f
	end

	def weekly_runs_count
		self.weekly_runs_count_on_date(Time.zone.now)
	end

	def weekly_runs_count_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).count
	end

	def weekly_runs_duration
		self.weekly_runs_duration_on_date(Time.zone.now)
	end

	def weekly_runs_duration_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).sum(:duration)
	end

	def monthly_runs_km
		self.monthly_runs_km_on_date(Time.zone.now)
	end

	def monthly_runs_km_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).sum(:distance).to_f
	end

	def monthly_runs_count
		self.weekly_runs_count_on_date(Time.zone.now)
	end

	def monthly_runs_count_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).count
	end

	def monthly_runs_duration
		self.weekly_runs_duration_on_date(Time.zone.now)
	end

	def monthly_runs_duration_on_date(date)
		time_obj = Time.zone.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).sum(:duration)
	end

	private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end

  def set_default_time_zone
  	self.time_zone ||= Time.zone.to_s
  end

	def create_category_and_initial_goal
		initital_category = "White"
		inititial_goal = "8"

		Category.create(first_day: Time.zone.now.at_beginning_of_month, last_day: Time.zone.now.at_end_of_month, name: initital_category,user_id:self.id)
		WeeklyGoal.create(first_day:Time.zone.now.at_beginning_of_week, last_day: Time.zone.now.at_end_of_week, number: Time.zone.now.at_beginning_of_week.strftime("%W").to_i, distance:inititial_goal, user_id:self.id)
	end

end
