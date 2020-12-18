module Helpers
  def current_uri
    URI.parse(current_url).request_uri
  end
end

World(Helpers)
