class LandingPageController < ApplicationController
  def show
    @page_title = t('landing_page.title_tag')
    @meta_tags_description = t('landing_page.meta_tag_description')

    @form = SearchForm.new
  end
end
