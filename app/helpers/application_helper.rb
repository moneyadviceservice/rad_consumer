module ApplicationHelper
  def page_tag(tag_name)
    t("#{controller_name}.#{action_name}.#{tag_name}")
  end

  def required_label(text)
    "#{text} <span class='visually-hidden'>#{t('global.required')}</span>*".html_safe
  end

  def rad_signup_url
    'https://radsignup.moneyadviceservice.org.uk/'
  end
end
