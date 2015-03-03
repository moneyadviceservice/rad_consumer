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
    object.types_of_advice.map do |advice_type|
      if object.public_send("#{advice_type}?")
        { 'match': { advice_type => true } }
      end
    end.compact
  end
end
