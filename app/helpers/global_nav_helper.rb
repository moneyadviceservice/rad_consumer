module GlobalNavHelper
  def category_url(id)
    global_nav_url("/#{locale}/categories/#{id}")
  end

  def global_nav_url(path)
    url = URI(path)
    unless url.host
      url = URI(Rails.configuration.mas_public_website_url)
      url.path = path
    end
    url.to_s
  end
end
