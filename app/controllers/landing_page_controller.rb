class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
    @remote_form = RemoteSearchForm.new
  end

  private

  def page
    params[:page].try(:to_i) || 1
  end
end
