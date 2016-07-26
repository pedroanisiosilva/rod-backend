class Api::V1::RunsController < Api::V1::BaseController

  def index
    users = User.all
    render json: users, each_serializer: Api::V1::UserSerializer
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    r = Run.find(params[:id])
    r.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def show
    user = User.find(params[:id])

    render(json: Api::V1::UserSerializer.new(user).to_json)
  end

  # GET /runs/new
  def new
      @run = Run.new()
  end

  # def update
  #   respond_to do |format|
  #     if @run.update(run_params)
  #       format.html { redirect_to @run, notice: 'Run was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @run }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @run.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
      @run = Run.find_by_id(params[:id])
      @run.update(duration: params[:duration], distance: params[:distance], datetime: Time.parse(params[:datetime]).to_datetime, updated_at: Time.zone.now)      
      if @run.save
        render(json: Api::V1::RunSerializer.new(@run).to_json)
    else
        render json: @run.errors, status: :unprocessable_entity
    end
  end

  def create
    byebug
    @run = Run.create(user_id: params[:user_id], rod_images_attributes: params[:rod_images_attributes], duration: params[:duration], created_at: Time.zone.now, distance: params[:distance], datetime: Time.parse(params[:datetime]).to_datetime, updated_at: Time.zone.now)

	  if @run.save
		  render(json: Api::V1::RunSerializer.new(@run).to_json)
	  else
		  render json: @run.errors, status: :unprocessable_entity
	  end
  end
	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params
      runp = params.require(:run).permit(:datetime, :distance, :duration, :speed, :pace, :user_id, :note, rod_images_attributes: [:image, :caption])
      runp["rod_images_attributes"].reject!{|_,t| t["caption"].empty? and t["image"] == nil }
      runp
    end
end

