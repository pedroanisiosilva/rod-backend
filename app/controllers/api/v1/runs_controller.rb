class Api::V1::RunsController < Api::V1::BaseController

  def index
    users = User.all

	 render json: users, each_serializer: Api::V1::UserSerializer

  end

  def show
    user = User.find(params[:id])

    render(json: Api::V1::UserSerializer.new(user).to_json)
  end

  # GET /runs/new
  def new

      @run = Run.new()

  end

  def create
    @run = Run.create(user_id: params[:user_id],duration: params[:duration], created_at: Time.zone.now, distance: params[:distance], datetime: Time.parse(params[:datetime]).to_datetime, updated_at: Time.zone.now)

	  if @run.save
		render(json: Api::V1::RunSerializer.new(@run).to_json)
	  else
		render json: @run.errors, status: :unprocessable_entity
	  end
  end
	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params
      params.require(:run).permit(:datetime, :distance, :user_id, :note)
    end
end

