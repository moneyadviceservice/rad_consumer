module SearchHelper
  def firm_has_qualifications_or_accreditations?(firm)
    return true if firm.adviser_qualification_ids.any? do |id|
      qualification_or_accreditation_key(id, :qualification) != 'ignored'
    end

    return true if firm.adviser_accreditation_ids.any? do |id|
      qualification_or_accreditation_key(id, :accreditation) != 'ignored'
    end

    false
  end

  def search_filter_options(form, page_name)
    render 'search/partials/filters/specialism_options', f: form, page_name: page_name
  end

  def render_logo(id, kind)
    key = qualification_or_accreditation_key(id, kind)
    return if key == 'ignored'
    return if key.match?(/^translation missing/)

    info = t("search.accreditations.items.#{key}")
    link_to glossary_path(locale: locale, anchor: key), class: "accreditation t-#{kind}" do
      image_tag "#{key}.png", alt: info[:title], class: 'accreditation__img'
    end
  end

  def firm_profile_link(firm_id, postcode)
    postcode_hash = postcode.present? ? { postcode: postcode } : {}
    hash = { id: firm_id }.merge(postcode_hash)
    firm_path(hash.merge(locale: locale))
  end

  private

  def qualification_or_accreditation_key(id, kind)
    I18n.t("#{kind}.ordinal.#{id}")
  end
end
