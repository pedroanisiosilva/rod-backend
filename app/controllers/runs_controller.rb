class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /runs
  # GET /runs.json
  def index

    if current_user.role.name == ("admin")

      if params[:user_id]
        @runs = User.find(params[:user_id]).runs.order('datetime DESC')
      else
        @runs = Run.order('datetime DESC')
      end

    else
      @runs = current_user.runs.order('datetime DESC')
    end

    # @runs = @runs.sort_by{|p| p.speed}

    respond_to do |format|
      format.html
      format.csv { send_data @runs.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end

  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  # GET /runs/new
  def new
    @user = current_user
    if @user.role.name == ("admin")
      @run = Run.new()
    else
      @run = @user.runs.create(params[:run])
    end
  end

  # GET /runs/1/edit
  def edit
  end

  # POST /runs
  # POST /runs.json
  def create

    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to @run, notice: 'Run was successfully created.' }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { render :new }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runs/1
  # PATCH/PUT /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to @run, notice: 'Run was successfully updated.' }
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def run_params
      runp = params.require(:run).permit(:datetime, :distance, :duration, :user_id, :note, rod_images_attributes: [:image, :caption])
      runp["rod_images_attributes"].reject!{|_,t| t["caption"].empty? }
      runp
    end
end
