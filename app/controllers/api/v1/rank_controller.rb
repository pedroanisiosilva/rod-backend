class Api::V1::RankController < Api::V1::BaseController
  PERIOD = { week: 0, month: 1, all: 2}


  def index

    case params[:period].to_i
      when PERIOD[:week]
        start_date = Time.now.beginning_of_day - ((Time.now.wday.day == 0 ? Time.now.wday.day : (Time.now.wday.day - 1.day)) + params[:qtd].to_i.week)
      when PERIOD[:month]
        start_date = Time.now.beginning_of_day - ((Time.now.mday.day == 0 ? Time.now.mday.day : (Time.now.mday.day - 1.day)) + params[:qtd].to_i.month)
      else
        start_date = Time.now.beginning_of_day - 10.years
    end

    runs = User.joins(:runs).select("user_id, name, sum(runs.distance) as ran_meters, avg(runs.distance / (runs.duration / 3600)) as speed, max(runs.distance / (runs.duration / 3600)) as top_speed").where("datetime >= :start_date", {start_date: start_date}).order(params[:order].present? ? params[:order] : "ran_meters")

    render(json: runs.to_json(except: :id))
  end

end
