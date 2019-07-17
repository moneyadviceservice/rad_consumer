class ChatOpeningHoursPresenter
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def open?
    object.now_open?
  end
end
