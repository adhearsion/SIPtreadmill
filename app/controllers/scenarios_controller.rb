class ScenariosController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.accessible_by(current_ability).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        case params[:type]
          when 'receiver_scenario'
            @scenarios = current_user.scenarios.where(receiver: true).order(:name).all
          when 'scenario'
            @scenarios = current_user.scenarios.where(receiver: false).order(:name).all
          else
            @scenarios = current_user.scenarios.order(:name).all
        end
        render json: @scenarios
      end
    end
  end

  # GET /scenarios/1 
  # GET /scenarios/1.json
  def show
    @scenario = Scenario.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scenario }
    end
  end

  # GET /scenarios/new
  # GET /scenarios/new.json
  def new
    @scenario = current_user.scenarios.new
    @scenario.registration_scenario = current_user.scenarios.new
    @registration_scenario = @scenario.registration_scenario

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scenario }
    end
  end

  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.accessible_by(current_ability).find(params[:id])
    unless @scenario.writable?
      redirect_to @scenario, alert: "Cannot edit a scenario that has already been used in a Test Run"
    end
    @registration_scenario = @scenario.registration_scenario || Scenario.new
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = current_user.scenarios.new(params[:scenario])
    @registration_scenario = current_user.scenarios.new(params[:registration_scenario]) if params[:registration_scenario]

    @registration_scenario.save if @registration_scenario
    @scenario.registration_scenario = @registration_scenario

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { render json: @scenario, status: 201, location: @scenario }
      else
        format.html { render action: "new" }
        format.json { render json: @scenario.errors, status: 422 }
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.json
  def update
    @scenario = Scenario.accessible_by(current_ability).find(params[:id])
    unless @scenario.writable?
      redirect_to @scenario, alert: "Cannot edit a scenario that has already been used in a Test Run"
    end
    if @scenario.receiver?
      if @scenario.registration_scenario
        @registration_scenario = @scenario.registration_scenario
      else
        @registration_scenario = Scenario.new
        @registration_scenario.scenario_id = @scenario.id
      end
      respond_to do |format|
	      if @scenario.update_attributes(params[:scenario]) && @registration_scenario.update_attributes(params[:registration_scenario])
		      format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
		      format.json { head :no_content }
	      else
		      flash[:error] = [@scenario.errors.full_messages, @registration_scenario.errors.full_messages].flatten.join ", "
		      format.html { render action: "edit" }
		      format.json { render json: @scenario.errors, status: 422 }
	      end
      end
    else
      respond_to do |format|
        if @scenario.update_attributes(params[:scenario])
          format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
          format.json { head :no_content }
        else
          flash[:error] = [@scenario.errors.full_messages]
          format.html { render action: "edit" }
          format.json { render json: @scenario.errors, status: 422 }
        end
      end
    end
  end
  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario = Scenario.accessible_by(current_ability).find(params[:id])
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to scenarios_url }
      format.json { head :no_content }
    end
  end
end
