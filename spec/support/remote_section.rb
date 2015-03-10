class RemoteSection < SitePrism::Section
  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'
  element :search, '.button--primary'
end
