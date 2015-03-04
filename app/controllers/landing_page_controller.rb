class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end
end
