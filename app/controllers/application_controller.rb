class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 本系統任何頁面都需要進行登入才能使用。Session 控制除外。
  before_filter :require_login, :except=>[:login]

  # 處理登入與未登入使用不同的 layout 版面
  layout :my_layout_setting

  def require_login
     unless logged_in?
        redirect_to "/users/login"
     end
  end

  def logged_in?
     if current_user.nil? || current_user.role.nil?
        false
     else
        true
     end
  end


  # 以下處理使用者登入，全站皆適用
  private
  def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # 處理版型，如上方程式設定
  def my_layout_setting
     if current_user.role == 1
        "admin"
     elsif current_user.role == 2
        "manager"
     elsif current_user.role == 3
        "worker"
     else
        # 有登入的話，使用預設版型
        "guest"
     end
  end

  helper_method :current_user

end
