class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    [].tap do |options|
      if object.face_to_face?
        options << {
          _geo_distance: {
            'advisers.location': object.coordinates.reverse,
            order: 'asc',
            unit: 'miles'
          }
        }
      end

      options << 'registered_name'
    end
  end

  def query
    {
      filtered: {
        filter: {
          bool: {
            must: build_filters
          }
        },
        query: {
          bool: {
            must: build_queries
          }
        }
      }
    }
  end

  private

  def build_filters
    [].tap do |filters|
      if object.phone_or_online?
        filters << { in: { other_advice_methods: object.remote_advice_method_ids } }
        filters << { missing: { field: :in_person_advice_methods } }
      end
    end
  end

  def build_queries
    investment_size_queries.tap do |expression|
      expression.push(*postcode_queries)        if object.face_to_face?
      expression.push(*types_of_advice_queries) if object.types_of_advice?
    end
  end

  def postcode_queries
    [
      {
        match: {
          postcode_searchable: true
        }
      },
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
      if object.retirement_income_products?
        unless object.any_pension_pot_size?
          filters << { match: { investment_sizes: object.pension_pot_size } }
        end
      end
    end
  end

  def types_of_advice?
    object.types_of_advice.present?
  end

  def types_of_advice_queries
    object.types_of_advice.map { |type| { range: { type => { gt: 0 } } } }
  end
end
