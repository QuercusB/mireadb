class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_student

  protected 

  def set_current_student
  	@current_student ||= Student.first
  end

  def current_student
  	@current_student
  end

end
