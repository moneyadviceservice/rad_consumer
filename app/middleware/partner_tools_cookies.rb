class PartnerToolsCookies
    COOKIE_SEPARATOR = "\n".freeze

    def initialize(app)
        @app = app
    end

    def call(env)
        status, headers, body = @app.call(env)

        # if (headers['X-Syndicated-Tool'].present? || env['HTTP_X_SYNDICATED_TOOL'].present?) &&
        # && Rack::Request.new(env).ssl?
        if (headers['Set-Cookie'].present? || env['HTTP_SET_COOKIE'].present?) 
            cookie = headers['Set-Cookie'] || env['HTTP_SET_COOKIE']
            cookies = cookie.split(COOKIE_SEPARATOR)
            new_cookies = []
            cookies.each do |cookie|
                next if cookie.blank?
                next if cookie =~ /;\s*secure/i

                new_cookies << "#{cookie}; SameSite=None; Secure"
            end

            headers['Set-Cookie'] = new_cookies.join(COOKIE_SEPARATOR)
        end

        [status, headers, body]
    end
end