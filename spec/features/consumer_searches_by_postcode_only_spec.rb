RSpec.feature 'Consumer searches by postcode only' do
  let(:landing_page) { LandingPage.new }

  scenario 'Consumer enters a invalid postcode' do
    given_i_am_on_the_rad_landing_page
    when_i_submit_a_invalid_postcode_search
    then_i_am_told_the_postcode_is_incorrect
  end

  scenario 'Postcode cannot be geocoded' do
    VCR.use_cassette(:postcode_cannot_be_geocoded) do
      given_i_am_on_the_rad_landing_page
      when_i_submit_a_postcode_that_cannot_be_geocoded
      then_i_am_told_the_postcode_is_incorrect
    end
  end

  def given_i_am_on_the_rad_landing_page
    landing_page.load
  end

  def when_i_submit_a_invalid_postcode_search
    landing_page.in_person.tap do |section|
      section.postcode.set 'B4D'
      section.search.click
    end
  end

  def when_i_submit_a_postcode_that_cannot_be_geocoded
    landing_page.in_person.tap do |section|
      section.postcode.set 'ZZ1 1ZZ'
      section.search.click
    end
  end

  def then_i_am_told_the_postcode_is_incorrect
    expect(landing_page.in_person).to be_invalid_postcode
  end
end
