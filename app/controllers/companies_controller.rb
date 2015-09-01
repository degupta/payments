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
    check_and_run do
      render
    end
  end

  def add_user
    check_and_run do
      user = User.where("email = ?", params[:email]).first
      if has_company? user, @company
        redirect_success(companies_path, :ok, "User already part of company")
      else
        user.companies << @company
        user.save!
        redirect_success(companies_path, :ok, "User added to company")
      end
    end
  end

  private

  def has_company? (u, c)
    u.companies.map {|c| c.id }.include? c.id
  end

  def check_and_run
    begin
      @company = Company.find((params[:id] || params[:company_id]).to_i)
      if has_company? @user, @company
        yield
      else
        redirect_error(companies_path, :unauthorized, "Unauthorized")
      end
    rescue Exception => e
      redirect_error(companies_path, :not_found, e.message)
    end
  end
end