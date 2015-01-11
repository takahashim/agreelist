class StatementsController < ApplicationController
  before_action :login_required, only: [:add_supporter, :create]
  before_action :admin_required, only: [:edit, :update, :destroy]

  def new_and_agree
    @statement = Statement.new
  end

  def create_and_agree
    @statement = Statement.new(params.require(:statement).permit(:content))

    if @statement.save
      Agreement.create(
        statement: @statement,
        individual: current_user,
        extent: 100)
      redirect_to @statement, notice: 'Statement was successfully created'
    else
      render action: "new"
    end
  end

  def add_supporter
    individual = Individual.find_or_create(params.require(:new_supporter)) #Individual.find_by_name(params[:new_supporter]) || Individual.create(name: params[:new_supporter])
    Agreement.create(
      statement_id: params[:statement_id],
      individual_id: individual.id,
      url: params[:source],
      extent: params[:add] == "disagreement" ? 0 : 100)
    redirect_to statement_path(params[:statement_id])
  end

  # GET /statements
  # GET /statements.json
  def index
    @statements = Statement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statements }
    end
  end

  # GET /statements/1
  # GET /statements/1.json
  def show
    @statement = Statement.find(params[:id])
    @agreements_in_favor = @statement.agreements_in_favor
    @agreements_against = @statement.agreements_against

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @statement }
    end
  end

  # GET /statements/new
  # GET /statements/new.json
  def new
    @statement = Statement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @statement }
    end
  end

  # GET /statements/1/edit
  def edit
    @statement = Statement.find(params[:id])
  end

  # POST /statements
  # POST /statements.json
  def create
    @statement = Statement.new(params.require(:statement).permit(:content))

    if @statement.save
      redirect_to @statement, notice: 'Statement was successfully created'
    else
      render action: "new"
    end
  end

  # PUT /statements/1
  # PUT /statements/1.json
  def update
    @statement = Statement.find(params[:id])

    respond_to do |format|
      if @statement.update_attributes(params.require(:statement).permit(:content))
        format.html { redirect_to @statement, notice: 'Statement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1
  # DELETE /statements/1.json
  def destroy
    @statement = Statement.find(params[:id])
    @statement.destroy

    respond_to do |format|
      format.html { redirect_to statements_url }
      format.json { head :no_content }
    end
  end
end
