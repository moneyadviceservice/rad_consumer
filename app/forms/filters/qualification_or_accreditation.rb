module Filters
  module QualificationOrAccreditation
    PREFIXES = {
      qualification: 'q',
      accreditation: 'a'
    }.freeze

    attr_accessor :qualification_or_accreditation

    def options_for_qualifications_and_accreditations
      (options_for(:qualification) + options_for(:accreditation)).sort
    end

    def selected_qualification_id
      selected_filter_id_for(:qualification)
    end

    def selected_accreditation_id
      selected_filter_id_for(:accreditation)
    end

    private

    def options_for(filter_type)
      filters = filters_for(filter_type)
      filters.map(&:reverse).map do |name, id|
        [name, "#{prefix_for(filter_type)}#{id}"]
      end
    end

    def prefix_for(filter_type)
      PREFIXES[filter_type]
    end

    def filters_for(filter_type)
      key_to_i = ->(k, v) { [k.to_s.to_i, v] }
      I18n.t("search.filter.#{filter_type}.ordinal").map(&key_to_i).to_h
    end

    def selected_filter_id_for(filter_type)
      is_desired_type = ->(prefix, item) { !!item[/^#{prefix}/] }
      extract_id = ->(item) { item[1..-1] }
      type_prefix = prefix_for(filter_type)

      [qualification_or_accreditation]
        .compact
        .select(&is_desired_type.curry[type_prefix])
        .map(&extract_id)
        .map(&:to_i)
        .first
    end
  end
end
