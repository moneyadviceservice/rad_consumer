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

  def firm_map_component(center:, adviserPinUrl:, officePinUrl:)
    options = {
      'data-dough-component': 'FirmMap',
      'data-dough-firm-map-config': {
        apiKey: ENV['GOOGLE_MAPS_API_KEY'],
        center: center,
        adviserPinUrl: adviserPinUrl,
        officePinUrl: officePinUrl
      }.to_json
    }
    content_tag :div, options do
      yield
    end
  end

  def feature_enabled?(flag_name)
    ENV[flag_name] == 'true'
  end

  def category_path(id)
    "/#{locale}/categories/#{id}"
  end
end
