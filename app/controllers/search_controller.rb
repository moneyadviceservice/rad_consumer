class SearchController < ApplicationController
  def index
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
      @form.fill_old_values
    elsif @form.old_values_present?
      @form.use_old_values
      @result = FirmRepository.new.search(@form.to_query, page: page)
      @form.fill_old_values
    else
      render 'landing_page/show'
    end
  end
end
