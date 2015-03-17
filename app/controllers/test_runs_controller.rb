class TestRunsController < ApplicationController
  before_filter :token_auth!
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /test_runs
  # GET /test_runs.json
  def index
    @test_runs = TestRun.accessible_by(current_ability).order("updated_at DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_runs }
    end
  end

  # GET /test_runs/1
  # GET /test_runs/1.json
  def show
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_run }
    end
  end

  # GET /test_runs/new
  # GET /test_runs/new.json
  def new
    @test_run = current_user.test_runs.new
    @scenario = Scenario.new
    @registration_scenario = @scenario.registration_scenario || Scenario.new
    @profile = Profile.new
    @target = Target.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_run }
    end
  end

  # GET /test_runs/1/edit
  def edit
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])

    redirect_to @test_run, notice: 'Test run cannot be updated after it has been run.' unless @test_run.state == 'pending'

    @scenario = Scenario.new
    @registration_scenario = @scenario.registration_scenario || Scenario.new
    @profile = Profile.new
    @target = Target.new
  end

  # GET /test_runs/1/copy
  def copy
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])

    new_test_run = @test_run.duplicate

    redirect_to new_test_run
  end

  # POST /test_runs
  # POST /test_runs.json
  def create
    @test_run = current_user.test_runs.new(params[:test_run])
    @test_run.user = current_user

    respond_to do |format|
      if @test_run.save
        format.html { redirect_to @test_run, notice: 'Test run was successfully created.' }
        format.json { render json: @test_run, status: :created, location: @test_run }
      else
        @scenario = Scenario.new
        @registration_scenario = @scenario.registration_scenario || Scenario.new
        @profile = Profile.new
        @target = Target.new
        format.html { render action: "new" }
        format.json { render json: @test_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /test_runs/1
  # PUT /test_runs/1.json
  def update
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      if @test_run.update_attributes(params[:test_run])
        format.html { redirect_to @test_run, notice: 'Test run was successfully updated.' }
        format.json { head :no_content }
      else
        @scenario = @test_run.scenario || Scenario.new
        @registration_scenario = @scenario.registration_scenario || Scenario.new
        @profile = @test_run.profile || Profile.new
        @target = @test_run.target || Target.new
        flash[:error] = @test_run.errors.full_messages
        format.html { render action: "edit" }
        format.json { render json: @test_run.errors, status: 422 }
      end
    end
  end

  # DELETE /test_runs/1
  # DELETE /test_runs/1.json
  def destroy
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])
    @test_run.destroy

    respond_to do |format|
      format.html { redirect_to test_runs_url }
      format.json { head :no_content }
    end
  end

  def enqueue
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])
    if @test_run.enqueue params[:password]
      redirect_to @test_run, notice: 'Test run successfully enqueued'
    else
      redirect_to @test_run, alert: 'Test run can not be enqueued again.'
    end
  end

  def cancel
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])
    if @test_run.cancel
      redirect_to @test_run, notice: 'Test run successfully canceled'
    else
      redirect_to @test_run, alert: 'Test run can not be canceled.'
    end
  end

  def stop
    @test_run = TestRun.accessible_by(current_ability).find(params[:id])
    if @test_run.stop
      redirect_to @test_run, notice: 'Test run successfully stopped'
    else
      redirect_to @test_run, alert: 'Test run can not be stopped.'
    end
  end

  private

  def token_auth!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
      sign_in user, store: false
    end
  end
end
