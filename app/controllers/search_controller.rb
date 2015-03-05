class SearchController < ApplicationController
  def index
    @page_title = t('search_results.title_tag')
    @meta_tag_description = t('search_results.meta_tag_description')

    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
    else
      render 'landing_page/show'
    end
  end

  private

  def page
    params[:page].try(:to_i) || 1
  end
end
