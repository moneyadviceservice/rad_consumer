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

    info = t("search.accreditations.items.#{key}")
    link_to "glossary/##{key}", class: "accreditation t-#{kind}" do
      image_tag "#{key}.png", alt: info[:title], class: 'accreditation__img'
    end
  end

  def qualification_or_accreditation_key(id, kind)
    kind.to_s.titleize.constantize.friendly_name(id)
  end
end
