class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end

  def search
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @results = FirmRepository.new.search(@form.as_json)
    else
      render :show
    end
  end
end
