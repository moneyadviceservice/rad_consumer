class RemoteSearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    'registered_name'
  end

  def query
    {
      'filtered': {
        'filter': {
          'bool': {
            'must': [
              {
                'in': {
                  'other_advice_methods': object.remote_advice_method_ids
                }
              }
            ]
          }
        }
      }
    }.tap do |query|
      if types_of_advice?
        query[:filtered][:filter][:bool][:must] << {
          'script': {
            'script': types_of_advice_filter_expression
          }
        }
      end
    end
  end

  private

  def types_of_advice_filter_expression
    object.types_of_advice.map { |field| "doc['#{field}'].value > 0" }.join(' && ')
  end

  def types_of_advice?
    object.types_of_advice.present?
  end
end
