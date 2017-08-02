Mas::Cms::Client.config do |c|
  c.timeout =       ENV['MAS_CMS_REQUEST_TIMEOUT'].to_i
  c.open_timeout =  ENV['MAS_CMS_REQUEST_TIMEOUT'].to_i
  c.host =          ENV['MAS_CMS_URL']
  c.retries =       1
  c.cache =         Rails.cache
  c.cache_gets =    false
end
