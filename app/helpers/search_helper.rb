module SearchHelper
  def results_order_notice_for_form(form)
    if form.face_to_face?
      I18n.t('search.distance_order_notice')
    elsif form.phone_or_online?
      I18n.t('search.alphabetical_order_notice')
    end
  end
end
