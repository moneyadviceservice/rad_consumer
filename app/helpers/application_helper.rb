module ApplicationHelper
  def page_tag(tag_name)
    t("#{controller_name}.#{action_name}.#{tag_name}")
  end

  def required_label(text)
    "#{text} <span class='visually-hidden'>#{t('global.required')}</span>*".html_safe
  end

  def validation_attributes_for(klass, field)
    klass.validation_attributes_for field
  end

  def empty_dough_validation_summary
    render partial: 'shared/empty_dough_validation_summary'
  end
end
