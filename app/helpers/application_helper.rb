module ApplicationHelper
  def page_tag(tag_name)
    t("#{controller_name}.#{action_name}.#{tag_name}")
  end

  def search_filter_options(form, page_name)
    render partial: 'landing_page/search_filter_options', locals: { f: form, page_name: page_name }
  end
end
