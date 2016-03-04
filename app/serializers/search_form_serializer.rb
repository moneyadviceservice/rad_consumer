class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    [].tap do |options|
      if object.face_to_face?
        options << {
          _geo_distance: {
            'advisers.location' => object.coordinates.reverse,
            order: 'asc',
            unit: 'miles'
          }
        }
      end

      options << '_score' if object.phone_or_online?
      options << 'registered_name'
    end
  end

  def query
    object.phone_or_online? ? phone_or_online_query : face_to_face_query
  end

  private

  def build_filters
    [].tap do |filters|
      if object.phone_or_online?
        filters << { in: { other_advice_methods: object.remote_advice_method_ids } }
        filters << { missing: { field: :in_person_advice_methods } }
      end

      if object.selected_qualification_id.present?
        filters << { in: { adviser_qualification_ids: [object.selected_qualification_id] } }
      end

      if object.selected_accreditation_id.present?
        filters << { in: { adviser_accreditation_ids: [object.selected_accreditation_id] } }
      end
    end
  end

  def build_queries
    investment_size_queries.tap do |expression|
      expression << { term: { _id: object.firm_id } } if object.firm_id.present?
      expression.push(*postcode_queries)        if object.face_to_face?
      expression.push(*types_of_advice_queries) if object.types_of_advice?
      expression.push(*service_queries) if object.services?
      expression.push(language_query) if object.language.present?
    end
  end

  def face_to_face_query
    {
      filtered: {
        filter: { bool: { must: build_filters } },
        query:  { bool: { must: build_queries } }
      }
    }
  end

  def phone_or_online_query
    {
      function_score: {
        query: face_to_face_query,
        random_score: { seed: object.random_search_seed }
      }
    }
  end

  def postcode_queries
    [
      { match: { postcode_searchable: true } },
      advisers_geo_query
    ]
  end

  def advisers_geo_query
    {
      nested: {
        path: 'advisers',
        filter: {
          bool: {
            must: range_intersects_consumer_location,
            should: reasonable_distance_from_consumer_location
          }
        }
      }
    }
  end

  def range_intersects_consumer_location
    {
      geo_shape: {
        range_location: {
          relation: 'intersects',
          shape: {
            type: 'point',
            coordinates: object.coordinates.reverse
          }
        }
      }
    }
  end

  def reasonable_distance_from_consumer_location
    {
      geo_distance: {
        distance: '750miles',
        location: object.coordinates.reverse
      }
    }
  end

  def investment_size_queries
    [].tap do |filters|
      unless object.any_pension_pot_size?
        filters << { match: { investment_sizes: object.pension_pot_size } }
      end
    end
  end

  def types_of_advice?
    object.types_of_advice.present?
  end

  def types_of_advice_queries
    object.types_of_advice.map { |type| { range: { type => { gt: 0 } } } }
  end

  def service_queries
    object.services.map { |type| { match: { type => true } } }
  end

  def language_query
    { match: { languages: object.language } }
  end
end
