class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    case
    when object.face_to_face?
      {}.tap do |expression|
        if types_of_advice?
          expression[:_script] = {
              script: types_of_advice_sorting_expression,
              type: 'number',
              order: 'desc'
          }
        end

        if object.face_to_face?
          expression[:_geo_distance] = {
            'advisers.location': object.coordinates.reverse,
            'order': 'asc',
            'unit': 'miles'
          }
        end
      end
    when object.phone_or_online?
      'registered_name'
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
      filters << { script: { script: types_of_advice_filter_expression } } if types_of_advice?
      filters << { in: { other_advice_methods: object.remote_advice_method_ids } } if object.phone_or_online?
    end
  end

  def build_queries
    investment_size_queries.tap do |expression|
      expression.push(*postcode_queries) if object.face_to_face?
    end
  end

  def postcode_queries
    [
      {
        match: {
          postcode_searchable: true
        }
      },
      {
        nested: {
          path: 'advisers',
          filter: {
            geo_distance: {
              distance: '650miles',
              location: object.coordinates.reverse
            }
          }
        }
      }
    ]
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

  def types_of_advice_sorting_expression
    chosen_types_of_advice_fields.join(' + ')
  end

  def types_of_advice_filter_expression
    chosen_types_of_advice_fields.map { |field| "#{field} > 0" }.join(' && ')
  end

  def chosen_types_of_advice_fields
    object.types_of_advice.map { |type| "doc['#{type}'].value" }
  end
end
