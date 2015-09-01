class BaseCompanyController < ApplicationController
  def check_and_run
    begin
      @company = Company.find((params[:company_id] || params[:id]).to_i)
      if @user.has_company? @company
        yield
      else
        redirect_error(redirect_path, :unauthorized, "Unauthorized")
      end
    rescue Exception => e
      redirect_error(redirect_path, :not_found, e.message)
    end
  end

  def redirect_path
    companies_path
  end
end