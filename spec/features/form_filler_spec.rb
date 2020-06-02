require 'rails_helper'

first_name_field = 'Field11'
last_name_field = 'Field12'
email_field = 'Field13'
phone_field = 'Field14'
location_selection_field = 'Field254'
location_names = { 'PDX' => 'Portland', 'SEA' => 'Seattle', 'WEB' => 'Online' }
location_fields = { 'Portland' => 'Field256', 'Seattle' => 'Field258', 'Online' => 'Field1323' }
over18_field = 'Field774'
diploma_field = 'Field775'

describe 'form filling' do
  it 'fills out /apply form for each track', js: true do
    CURRENT_TRACKS.each_with_index do |track, index|
      location = location_names[track.split[3]]
      visit "https://www.epicodus.com/?gclid=test_gclid_#{index+1}&sqf_source=test_sqf_source_#{index+1}"
      visit "https://www.epicodus.com/sign-up"
      sleep 5
      page.within_frame('wufooFormz12e0pp21gzvlw1') do
        fill_in first_name_field, with: 'Automated'
        fill_in last_name_field, with: "Test"
        fill_in email_field, with: "automated-test-#{location.downcase}-#{index+1}@example.com"
        fill_in phone_field, with: '123-456-7890'
        select location, from: location_selection_field
        select track, from: location_fields[location]
        all('input[value=Yes]').map(&:choose)
        click_button 'Sign up!'
      end
      sleep 5
      expect(page).to have_content 'Thanks for signing up!'
    end
  end
end
