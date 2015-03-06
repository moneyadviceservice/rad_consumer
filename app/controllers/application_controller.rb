class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  private

  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected

  def page
    params[:page].try(:to_i) || 1
  end
end
