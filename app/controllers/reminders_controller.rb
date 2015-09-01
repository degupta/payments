class RemindersController < BaseCompanyController
  def index
    check_and_run do
      render
    end
  end

  def create
    check_and_run do
      r = Reminder.new(reminder_params)
      r.company = @company
      r.save!
      redirect_success(company_reminders_path(@company.id), :ok, "Reminder created")
    end
  end

  def delete
    check_and_run do
      begin
        r = Reminder.find(params[:reminder_id])
        r.delete!
        redirect_success(company_reminders_path(@company.id), :ok, "Reminder deleted")
      rescue Exception => e
        redirect_error(company_reminders_path(@company.id), :internal_error, e.message)  
      end
    end
  end

  private

  def reminder_params
    params.permit(:party, :party_number, :broker, :broker_number, :bill_date, :bill_no, :amount, :due_date, :repeat)
  end
end
