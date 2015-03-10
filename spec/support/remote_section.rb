class RemoteSection < SitePrism::Section
  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'
  element :search, '.button--primary'

  def invalid_advice_methods?
    has_css?('.field_with_errors .t-advice_methods')
  end
end
