class SearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    {
      '_geo_distance' => {
        'advisers.location' => object.coordinates.reverse,
        'order' => 'asc',
        'unit' => 'miles'
      }
    }
  end

  def query
    {
      'bool': {
        'must': (build_postcode_filters + build_types_of_advice_filters)
      }
    }
  end

  private

  def build_postcode_filters
    [
      {'match': {'postcode_searchable': true }},
      {
        'nested' => {
          'path' => 'advisers',
          'filter' => {
            'geo_distance' => {
              'distance' => '650miles',
              'location' => object.coordinates.reverse
            }
          }
        }
      }
    ]
  end

  def build_types_of_advice_filters
    [].tap do |filters|
      filters << { match: { 'options_when_paying_for_care': true } } if object.options_when_paying_for_care == '1'
      filters << { match: { 'equity_release': true } } if object.equity_release == '1'
      filters << { match: { 'inheritance_tax_planning': true } } if object.inheritance_tax_planning == '1'
      filters << { match: { 'wills_and_probate': true } } if object.wills_and_probate == '1'
    end
  end
end
