class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
    @remote_form = RemoteSearchForm.new
  end
end
