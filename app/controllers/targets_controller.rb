class TargetsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /targets
  # GET /targets.json
  def index
    @targets = Target.accessible_by(current_ability).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @targets }
    end
  end

  # GET /targets/1
  # GET /targets/1.json
  def show
    @target = Target.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/new
  # GET /targets/new.json
  def new
    @target = current_user.targets.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/1/edit
  def edit
    @target = Target.accessible_by(current_ability).find(params[:id])
  end

  # POST /targets
  # POST /targets.json
  def create
    @target = current_user.targets.new(params[:target])

    respond_to do |format|
      if @target.save
        format.html { redirect_to @target, notice: 'Target was successfully created.' }
        format.json { render json: @target, status: 201, location: @target }
      else
        format.html { render action: "new" }
        format.json { render json: @target.errors, status: 422 }
      end
    end
  end

  # PUT /targets/1
  # PUT /targets/1.json
  def update
    @target = Target.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      if @target.update_attributes(params[:target])
        format.html { redirect_to @target, notice: 'Target was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /targets/1
  # DELETE /targets/1.json
  def destroy
    @target = Target.accessible_by(current_ability).find(params[:id])
    @target.destroy

    respond_to do |format|
      format.html { redirect_to targets_url }
      format.json { head :no_content }
    end
  end
end
