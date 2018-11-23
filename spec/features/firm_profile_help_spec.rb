RSpec.feature 'Help section on a firm profile', :vcr do
  let(:profile_page) { ProfilePage.new }

  scenario 'viewing information on face to face firm' do
    with_elastic_search! do
      given_firm_with_offices
      when_i_view_the_firm_profile
      then_i_should_see_how_near_adviser_text
      then_i_should_not_see_phone_or_online_text
    end
  end

  scenario 'viewing information on remote only firm' do
    with_elastic_search! do
      given_firm_with_remote_advice
      when_i_view_the_remote_firm_profile
      then_i_should_see_phone_or_online_text
      then_i_should_not_see_how_near_adviser_text
    end
  end

  def given_firm_with_offices
    with_fresh_index! do
      @firm = create(:firm, website_address: 'http://www.foobar.com')
    end
  end

  def given_firm_with_remote_advice
    with_fresh_index! do
      @remote_firm = create(:firm, :with_remote_advice)
    end
  end

  def when_i_view_the_firm_profile
    profile_page.load(firm: @firm.id)
    expect(profile_page).to be_displayed
  end

  def when_i_view_the_remote_firm_profile
    profile_page.load(firm: @remote_firm.id)
    expect(profile_page).to be_displayed
  end

  def then_i_should_see_how_near_adviser_text
    expect(profile_page.side_info).to have_content('How near is your adviser?')
  end

  def then_i_should_not_see_phone_or_online_text
    expect(profile_page.side_info).not_to have_content('Phone or online only advisers')
  end

  def then_i_should_not_see_how_near_adviser_text
    expect(profile_page.side_info).not_to have_content('How near is your adviser?')
  end

  def then_i_should_see_phone_or_online_text
    expect(profile_page.side_info).to have_content('Phone or online only advisers')
  end
end
