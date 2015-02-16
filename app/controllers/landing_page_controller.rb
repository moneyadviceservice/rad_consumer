class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end

  def search
    render nothing: true
  end
end
