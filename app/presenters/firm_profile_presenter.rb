class FirmProfilePresenter < SimpleDelegator
  def type_of_advice_method
    return :face_to_face if in_person_advice_methods.present?

    :remote
  end
end
