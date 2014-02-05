class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # 處理登入與未登入使用不同的 layout 版面
  layout :my_layout_setting


  # 以下處理使用者登入，全站皆適用
  private
  def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # 處理版型，如上方程式設定
  def my_layout_setting
     if current_user.nil? || current_user.role.nil?
        # 尚未登入，或者尚未提昇管理權限 (user.role)
        "notlogin"
     else
        # 有登入的話，使用預設版型
        "application"
     end
  end

  helper_method :current_user

end
