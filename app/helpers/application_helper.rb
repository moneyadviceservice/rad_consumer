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

  def heading_tag(content_or_options_with_block = nil, options = {}, &block)
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      value   = capture(&block).strip
    else
      value = content_or_options_with_block
    end

    level = options.delete(:level) { 1 }

    content_tag("h#{level}", value.html_safe, options.merge('role' => :heading, 'aria-level' => level))
  end

end
