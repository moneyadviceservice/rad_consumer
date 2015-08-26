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

  def svg_icon(name, options = {})
    content_tag :svg, { xmlns: 'http://www.w3.org/2000/svg', focusable: false }.merge(options) do
      tag :use, 'xlink:href' => "#icon-#{name}"
    end
  end
end
