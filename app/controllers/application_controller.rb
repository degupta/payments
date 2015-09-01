class ApplicationController < ActionController::Base

  before_filter :login_user

  def login_user
    begin
      @user = AuthToken.find_user request.headers["Authorization"]["Token ".length..-1]
    rescue
      begin
        @user = User.find(session[:user_id])
      rescue
      end
    end
    on_no_user unless @user
  end

  def on_no_user
    redirect_error(login_path)
  end

  def redirect_error(path, json_resp = :unauthorized, msg = nil)
    respond_to do |format|
      format.html {
        flash[:error] = msg if msg
        redirect_to path
      }
      format.json { head(json_resp) }
      format.all { head(json_resp) }
    end
  end

  def redirect_success(path, json_resp = :ok, msg = nil)
    respond_to do |format|
      format.html {
        flash[:success] = msg if msg
        redirect_to path
      }
      format.json { head(json_resp) }
    end
  end
end
