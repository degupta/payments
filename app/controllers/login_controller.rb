class LoginController < ApplicationController

  def index
    if @user
      redirect_to companies_path
    else
      render
    end
  end

  def on_no_user
  end

  def login
    if params[:email] && params[:password]
      @user = User.where("email = ?", params[:email]).first
      if @user && BCrypt::Password.new(@user.hashed_password).is_password?(params[:password])
        respond_to do |format|
          format.html {
            session[:user_id] = @user.id
            redirect_to companies_path
          }
          format.json {
            render json: {
              auth_token: AuthToken.create_token(@user.id),
              user: @user.as_json
            }
          }
        end
      else
        session[:user_id] = nil
        redirect_error(login_path, :unauthorized, "Email or password was wrong")
      end
    else
      session[:user_id] = nil
      redirect_error(login_path, :unauthorized, "Email or password was wrong")
    end
  end

  def logout
    session.delete(:user_id)
    redirect_success(login_path)
  end

  def forgot_password
    if request.post?
      if params[:email]
        begin
          user = User.where("email = ?", params[:email]).first
          raise "Cannot find user #{params[:email]}" unless user
          password = user.reset_password
          user.save!
          SignUpMailer.sign_up_email(user, password, true).deliver
          flash[:success] = "Password reset intstructions have been sent to your email"
          redirect_to login_path and return
        rescue Exception => e
          flash[:error] = e.message
        end
      end
    end
    render
  end
end