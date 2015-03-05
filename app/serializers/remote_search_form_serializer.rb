class RemoteSearchFormSerializer < ActiveModel::Serializer
  self.root = false

  attributes :sort, :query

  def sort
    'registered_name'
  end

  def query
    {
      'filtered' => {
        'filter' => {
          'in' => {
            'other_advice_methods' => remote_advice_method_ids
          }
        }
      }
    }
  end

  private

  def remote_advice_method_ids
    methods = []
    methods << 'Advice online (e.g. by video call / conference / email)' if object.online_checkbox == '1'
    methods << 'Advice by telephone' if object.by_phone_checkbox == '1'

    OtherAdviceMethod.where("name in (?)", methods).ids
  end
end
