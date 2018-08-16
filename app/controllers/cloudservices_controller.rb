class CloudservicesController < ApplicationController
  before_action :logged_in_user
  before_action :set_cloudservice, only: [:show, :edit, :update, :destroy]

  # GET /cloudservices
  # GET /cloudservices.json
  def index
    @search = OpenStruct.new params[:search]
    @cloudservices = Cloudservice.all
    @cloudservices = build_search(@cloudservices, @search)

    @cloudservices = @cloudservices.order(expired_at: @search.expired_at) if @search.expired_at.present?
    @cloudservices
  end

  # GET /cloudservices/1
  # GET /cloudservices/1.json
  def show
  end

  # GET /cloudservices/new
  def new
    @cloudservice = Cloudservice.new
  end

  # GET /cloudservices/1/edit
  def edit
  end

  # POST /cloudservices
  # POST /cloudservices.json
  def create
    @cloudservice = Cloudservice.new(cloudservice_params)

    respond_to do |format|
      if @cloudservice.save
        format.html { redirect_to cloudservices_path, notice: 'Cloudservice was successfully created.' }
        format.json { render :show, status: :created, location: @cloudservice }
      else
        format.html { render :new }
        format.json { render json: @cloudservice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cloudservices/1
  # PATCH/PUT /cloudservices/1.json
  def update
    respond_to do |format|
      if @cloudservice.update(cloudservice_params)
        format.html { redirect_to @cloudservice, notice: 'Cloudservice was successfully updated.' }
        format.json { render :show, status: :ok, location: @cloudservice }
      else
        format.html { render :edit }
        format.json { render json: @cloudservice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloudservices/1
  # DELETE /cloudservices/1.json
  def destroy
    @cloudservice.destroy
    respond_to do |format|
      format.html { redirect_to cloudservices_url, notice: 'Cloudservice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def build_search(records, search)
    if search.query.present?
      cols = [
        '`cloudservices`.`code` LIKE :query',
        '`cloudservices`.`vendor` LIKE :query',
      ]
      records = records.where(cols.join(" OR "), {query: "%#{search.query}%"})
    end

    records
  end

  def set_cloudservice
    @cloudservice = Cloudservice.find(params[:id])
  end

  def cloudservice_params
    params.require(:cloudservice).permit(:code, :vendor, :expired_at)
  end

  def logged_in_user
    unless logged_in?
    redirect_to login_url
    end
  end
end
