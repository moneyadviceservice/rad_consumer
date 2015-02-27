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
  end
end
