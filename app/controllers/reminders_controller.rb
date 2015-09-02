class RemindersController < BaseCompanyController
  def index
    check_and_run do
      render
    end
  end

  def create
    check_and_run do
      begin
        r = Reminder.new(reminder_params)
        r.company = @company
        r.save!
        redirect_success(company_reminders_path(@company.id), :ok, "Reminder created")
      rescue Exception => e
        redirect_error(company_reminders_path(@company.id), :precondition_failed, e.message)
      end
    end
  end

  def destroy
    check_and_run do
      r = Reminder.find(params[:id])
      begin
        r.destroy!
        redirect_success(company_reminders_path(@company.id), :ok, "Reminder deleted")
      rescue Exception => e
        redirect_error(company_reminders_path(@company.id), :internal_error, e.message)  
      end
    end
  end

  def sent_message
    check_and_run do
      r = Reminder.find(params[:reminder_id])
      begin
        r.last_reminder = Date.parse(params[:date], "%d-%m-%Y") if params[:date]
        r.save!
        redirect_success(company_reminders_path(@company.id), :ok, "Reminder Updated")
      rescue Exception => e
        redirect_error(company_reminders_path(@company.id), :internal_error, e.message)
      end
    end
  end

  def redirect_path
    if @company
      company_reminders_path(@company.id)
    else
      super
    end
  end

  private

  def reminder_params
    if params[:bill_date]
      params[:bill_date] = Date.parse(params[:bill_date], "%d-%m-%Y")
      params[:due_date] = params[:bill_date] + params[:due_days].to_i  if params[:due_days]
    end
    params.permit(:party, :party_number, :broker, :broker_number, :bill_date, :bill_no, :amount, :due_date, :repeat)
  end
end
