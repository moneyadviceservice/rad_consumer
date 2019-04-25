class CalloutSection < SitePrism::Section
  element :minimum_fee, '.callout__item:nth-of-type(1)'
  element :minimum_pot_size, '.callout__item:nth-of-type(2)'
  element :free_initial_meeting, '.callout__item:nth-of-type(3)'
end

class OfficesSection < SitePrism::Section
  element :address, '.t-address'
  element :postcode, '.t-postcode'
  element :telephone, '.office__telephone'

  def email
    root_element.find('.office__email > a')['href'].partition(':').last
  end

  def website
    root_element.find('.office__website > a')['href']
  end
end

class AdvisersSection < SitePrism::Section
  element :name, '.t-name'
  element :postcode, '.t-postcode'
end

class ProfilePage < SitePrism::Page
  # require_relative './office_section'
  # require_relative './adviser_section'
  set_url '/en/firms/{id}'
  set_url_matcher %r{/(en|cy)/id}

  sections :offices, OfficesSection, '.t-office'
  sections :advisers, AdvisersSection, '.t-adviser'

  # the dough component re-writes the DOM so we can't attach a test class
  element :offices_tab, '[data-dough-tab-selector-trigger="2"]'
  element :advisers_tab, '[data-dough-tab-selector-trigger="3"]'

  element :name, '.firm__name'
  element :telephone, '.t-telephone'
  element :email_button, '.t-email'
  element :website, '.t-website'
  element :side_info, '.l-firm__side'

  section :callout, CalloutSection, '.callout'

  elements :services, '.plain_list > li'
  elements :advice_methods, '.advice-method__list > li'

  element :nearest_adviser_distance, '.firm__header > div.t-distance_to_the_nearest_adviser'

  elements :recently_viewed_firms, '.recently-viewed__item > a'

  def email
    email_button['href'].partition(':').last
  end
end
