class Api::V1::UserSerializer < Api::V1::BaseSerializer
  include ApplicationHelper
  attributes :id, :email, :name,  :status, :role, :created_at, :updated_at, :stats
  has_many :runs

  def role
    object.role.name
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end

  def stats
    weeks_array = Array.new
    week_hash = Hash.new
    wg = WeeklyGoal.where(:user_id => object.id).order('first_day DESC')

    wg.each do |week| 

      week_stats = Hash.new
      week_stats["number"]    = week.number
      week_stats["goal"]      = week.distance.to_f
      week_stats["run_count"] = object.weekly_runs_count_on_date(week.first_day)
      week_stats["total_kms"] = object.weekly_runs_km_on_date(week.first_day)
      week_stats["pace"]      = pace_helper(object.weekly_runs_duration_on_date(week.first_day),object.weekly_runs_km_on_date(week.first_day))

      weeks_array.push(week_stats)
    end

    week_hash["week"] = weeks_array

  end
end