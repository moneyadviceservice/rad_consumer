module SearchFormSort
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

      options << '_score' if object.phone_or_online? || object.firm_name_search?
      options << 'registered_name'
    end
  end
end
