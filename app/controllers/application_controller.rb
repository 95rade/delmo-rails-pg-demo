class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::NoDatabaseError, with: :no_database_error
  rescue_from PG::ConnectionBad, with: :no_database_error
  protect_from_forgery with: :exception

  def no_database_error
    render "home/no_database_error"
  end
end
