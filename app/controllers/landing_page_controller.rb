class LandingPageController < ApplicationController
  def show
    @form = SearchForm.new
  end

  def search
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      render nothing: true
    else
      render :show
    end
  end
end
