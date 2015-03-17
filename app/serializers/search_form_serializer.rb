class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    {}.tap do |expression|
      if types_of_advice?
        expression['_script'] = {
          'script': types_of_advice_sorting_expression,
          'type': 'number',
          'order': 'desc'
        }
      end

      if object.face_to_face?
        expression['_geo_distance'] = {
          'advisers.location': object.coordinates.reverse,
          'order': 'asc',
          'unit': 'miles'
        }
      end
    end
  end

  def query
    {
      'filtered': {
        'filter': {
          'script': {
            'script': types_of_advice_filter_expression
          }
        },
        'query': {
          'bool': {
            'must': (build_postcode_filters + build_investment_sizes_filter)
          }
        }
      }
    }.tap do |expression|
      expression[:filtered].delete(:filter) unless types_of_advice?
    end
  end

  private

  def build_postcode_filters
    [
      {
        'match': {
          'postcode_searchable': true
        }
      },
      {
        'nested': {
          'path': 'advisers',
          'filter': {
            'geo_distance': {
              'distance': '650miles',
              'location': object.coordinates.reverse
            }
          }
        }
      }
    ]
  end

  def types_of_advice?
    object.types_of_advice.present?
  end

  def types_of_advice_filter_expression
    chosen_types_of_advice_fields.map { |field| "#{field} > 0" }.join(' && ')
  end

  def types_of_advice_sorting_expression
    chosen_types_of_advice_fields.join(' + ')
  end

  def chosen_types_of_advice_fields
    object.types_of_advice.map { |type| "doc['#{type}'].value" }
  end

  def build_investment_sizes_filter
    [].tap do |filters|
      if object.retirement_income_products?
        unless object.any_pension_pot_size?
          filters << { 'match': { 'investment_sizes' => object.pension_pot_size } }
        end
      end
    end
  end
end
