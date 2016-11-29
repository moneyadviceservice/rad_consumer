def and_i_am_on_the_results_page_after_a_previous_search
  landing_page.load
  landing_page.in_person.tap do |f|
    f.face_to_face.set true
    f.postcode.set 'RG2 9FL'
    f.search.click
  end

  expect(results_page).to be_displayed
end

def and_i_clear_any_filters_from_the_previous_search
  results_page.search_form.tap do |f|
    f.face_to_face.set false
    f.phone_or_online.set false

    f.postcode.set nil

    f.retirement_income_products.set false
    f.pension_pot_size.set SearchForm::ANY_SIZE_VALUE
    f.pension_transfer.set false
    f.options_when_paying_for_care.set false
    f.equity_release.set false
    f.inheritance_tax_planning.set false
    f.wills_and_probate.set false
  end
end

def and_i_select_face_to_face_advice
  results_page.search_form.face_to_face.set true
end

def and_i_select_phone_or_online_advice
  results_page.search_form.phone_or_online.set true
end

def and_i_enter_a_valid_postcode(postcode)
  results_page.search_form.postcode.set postcode
end

def when_i_submit_the_search
  results_page.search_form.search.click
end
