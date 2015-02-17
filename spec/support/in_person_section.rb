class InPersonSection < SitePrism::Section
  element :postcode, '.t-postcode'
  element :search, '.button--primary'

  def invalid_postcode?
    has_css?('.field_with_errors .t-postcode')
  end
end
