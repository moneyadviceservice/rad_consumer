# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data, *%w[fonts.gstatic.com fonts.googleapis.com]
  policy.img_src     :self, :https, :data, *%w[
    i.ytimg.com
    yt3.ggpht.com
    www.youtube.com
    maps.gstatic.com
  ]
  policy.object_src  :none
  policy.script_src  :self, :https, :unsafe_inline, *%w[
    assets.adobedtm.com
    www.moneyhelper.org.uk
    static.cloudflareinsights.com
    www.googletagmanager.com
    www.youtube.com
    static.doubleclick.net
    www.google.com
    play.google.com
    legacymasassets.blob.core.windows.net
    maps.google.com
  ]
  policy.style_src   :self, :https, :unsafe_inline, *%w[
    www.youtube.com
    legacymasassets.blob.core.windows.net
    fonts.googleapis.com
  ]

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
