class ProfessionsController < ApplicationController
  before_action :profession_rights_required
  before_action :find_profession, only: [:show, :edit, :update, :destroy]

  # GET /professions
  def index
    @professions = Profession.all
  end

  # GET /professions/new
  def new
    @profession = Profession.new
  end

  # GET /professions/1/edit
  def edit
  end

  # POST /professions
  def create
    @profession = Profession.new(profession_params)

    if @profession.save
      redirect_to professions_path, notice: 'Comment category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /professions/1
  def update
    if @profession.update(profession_params)
      redirect_to professions_path, notice: 'Comment category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /professions/1
  def destroy
    @profession.destroy
    redirect_to professions_url, notice: 'Comment category was successfully destroyed.'
  end

  private
    def find_profession
      @profession = Profession.find(params[:id])
    end

    def profession_params
      params.require(:profession).permit(:name)
    end
end
