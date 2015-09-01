class CompaniesController < ApplicationController
  def index
    render
  end

  def create
    begin
      c = Company.new
      Company.transaction do
        c.name = params[:name]
        c.user_id = @user.id
        c.save!
        @user.companies << c
        @user.save!
      end
      redirect_success(companies_path(c.id), :ok, "Company created")
    rescue Exception => e
      redirect_error(companies_path, :precondition_failed, e.message)
    end
  end

  def show
    begin
      @company = Company.find(params[:id].to_i)
      render
    rescue Exception => e
      redirect_error(companies_path, :not_found, e.message)
    end
  end
end