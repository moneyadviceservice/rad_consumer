class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    {
      '_script': {
        'script': types_of_advice_sorting_expression,
        'type': 'number',
        'order': 'desc'
      },
      '_geo_distance': {
        'advisers.location': object.coordinates.reverse,
        'order': 'asc',
        'unit': 'miles'
      }
    }.tap do |expression|
      expression.delete(:_script) unless types_of_advice?
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
      if object.pension_pot?
        filters << { 'match': { 'advises_on_investments' => true } }
        filters << { 'match': { 'investment_sizes' => object.pension_pot_size } } unless object.any_pension_pot_size?
        filters << { 'match': { 'investment_transfers' => true } } if object.pension_pot_transfer?
      end
    end
  end
end
