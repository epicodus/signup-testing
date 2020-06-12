require 'rails_helper'

first_name_field = 'Field11'
last_name_field = 'Field12'
email_field = 'Field13'
phone_field = 'Field14'
location_selection_field = 'Field254'
location_names = { 'PDX' => 'Portland', 'SEA' => 'Seattle', 'WEB' => 'Online' }
location_fields = { 'Portland' => 'Field256', 'Seattle' => 'Field258', 'Online' => 'Field1323' }

describe 'form filling' do
  it 'fills out /sign-up form for each track', js: true do
    CURRENT_TRACKS.each_with_index do |track, index|
      location = location_names[track.split[3]]
      visit "https://www.epicodus.com/sign-up"
      sleep 5
      page.within_frame('wufooFormz12e0pp21gzvlw1') do
        fill_in first_name_field, with: 'Test'
        fill_in last_name_field, with: "#{track}"
        fill_in email_field, with: "#{track.parameterize}|#{SecureRandom.urlsafe_base64(5)}@mortalwombat.net"
        fill_in phone_field, with: "#{index}#{index}#{index}-#{index+1}#{index+1}#{index+1}-#{index+2}#{index+2}#{index+2}#{index+2}"
        select location, from: location_selection_field
        select track, from: location_fields[location]
        all('input[value=Yes]').map(&:choose)
        click_button 'Sign up!'
      end
      sleep 5
    end
  end
end
