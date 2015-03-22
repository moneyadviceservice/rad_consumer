class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end

  def search_filter_options_description?
    true
  end

  helper_method :search_filter_options_description?
end
