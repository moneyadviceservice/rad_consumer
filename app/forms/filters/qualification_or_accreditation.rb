module Filters
  module QualificationOrAccreditation
    attr_accessor :qualification_or_accreditation

    def options_for_qualifications_and_accreditations
      (options_for(Qualification) + options_for(Accreditation)).sort
    end

    def selected_qualification_id
      selected_filter_id_for(Qualification)
    end

    def selected_accreditation_id
      selected_filter_id_for(Accreditation)
    end

    private

    def options_for(model)
      filters = filters_for(model)
      model
        .where(order: filters.keys)
        .pluck(:order, :id)
        .map { |order, id| [filters[order], "#{prefix_for(model)}#{id}"] }
    end

    def prefix_for(model)
      model.model_name.singular[0]
    end

    def filters_for(model)
      key_to_i = ->(k, v) { [k.to_s.to_i, v] }
      I18n.t("search.filter.#{model.model_name.i18n_key}.ordinal").map(&key_to_i).to_h
    end

    def selected_filter_id_for(model)
      is_desired_type = ->(prefix, item) { !!item[/^#{prefix}/] }
      extract_id = ->(item) { item[1..-1] }
      type_prefix = prefix_for(model)

      [qualification_or_accreditation]
        .compact
        .select(&is_desired_type.curry[type_prefix])
        .map(&extract_id)
        .map(&:to_i)
        .first
    end
  end
end
