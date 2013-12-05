class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.accessible_by(current_ability).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = current_user.profiles.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.accessible_by(current_ability).find(params[:id])
    unless @profile.writable?
      redirect_to @profile, alert: "Cannot edit a profile that has already been used in a Test Run"
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = current_user.profiles.new(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: 201, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: 422 }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.accessible_by(current_ability).find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end
end
