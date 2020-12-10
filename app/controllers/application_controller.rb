class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  BANNER_DISMISSED_COOKIE_NAME = '_covid_banner'.freeze
  BANNER_DISMISSED_COOKIE_VALUE = 'y'.freeze

  include Chat

  before_action :set_locale
  before_action :set_layout

  def covid_banner_dismissed?
    cookies.permanent[BANNER_DISMISSED_COOKIE_NAME] != BANNER_DISMISSED_COOKIE_VALUE
  end

  helper_method :covid_banner_dismissed?

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

  def not_found
    {
      file: 'public/404.html',
      status: :not_found,
      layout: false
    }
  end

  def set_layout
    self.class.layout parent_template
  end

  def parent_template
    if syndicated_tool_request?
      'syndicated/application'
    else
      'application'
    end
  end

  def syndicated_tool_request?
    !!request.headers['X-Syndicated-Tool']
  end
end
