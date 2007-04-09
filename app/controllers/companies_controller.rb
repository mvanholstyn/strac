class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.find(:all)

    respond_to do |format|
      format.html { render :action => "index.erb" }
      format.xml { render :xml => @companies.to_xml }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html { render :action => "show.erb" }
      format.xml { render :xml => @company.to_xml }
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1;edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to company_url(@company) }
        format.xml { head :created, :location => company_url(@company) }
      else
        format.html { render :action => "new.erb" }
        format.xml { render :xml => @company.errors.to_xml }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to company_url(@company) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit.erb" }
        format.xml { render :xml => @company.errors.to_xml }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.xml { head :ok }
    end
  end
end
