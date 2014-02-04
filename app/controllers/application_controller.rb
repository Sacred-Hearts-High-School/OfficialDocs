class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # 以下處理使用者登入，全站皆適用
  private
  def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
