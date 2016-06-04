class WeekStatusController < ApplicationController

  # GET /week_status
  # GET /week_status.json
  def index

    @users = User.all

  end

end
