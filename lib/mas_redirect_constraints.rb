class MasRedirectConstraints
  def initialize(redirect: true)
    @redirect = redirect
  end

  def matches?(request)
    return true unless @redirect

    request.host.include?(legacy_host)
  end

  private

  def legacy_host
    ENV.fetch('LEGACY_HOST') { 'directory.moneyadviceservice.org.uk' }
  end
end
