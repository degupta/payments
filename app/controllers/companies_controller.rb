class CompaniesController < BaseCompanyController
  def index
    respond_to do |format|
      format.html { render }
      format.json { render json: @user.companies }
    end
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
      redirect_success(company_path(c.id), :ok, "Company created")
    rescue Exception => e
      redirect_error(companies_path, :precondition_failed, e.message)
    end
  end

  def show
    check_and_run do
      render
    end
  end

  def pending_reminders
    check_and_run do
      @pending_reminders = @company.pending_reminders
      respond_to do |format|
        format.html { render }
        format.json { render json: @pending_reminders.map {|r| r.as_json} }
      end
    end
  end

  def add_user
    check_and_run do
      user = User.where("email = ?", params[:email]).first
      if user.has_company? @company
        redirect_success(companies_path, :ok, "User already part of company")
      else
        user.companies << @company
        user.save!
        redirect_success(companies_path, :ok, "User added to company")
      end
    end
  end
end