class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end

  def search
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query)
    else
      render :show
    end
  end
end
