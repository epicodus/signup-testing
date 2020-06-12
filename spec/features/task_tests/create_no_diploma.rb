require 'rails_helper'

first_name_field = 'Field11'
last_name_field = 'Field12'
email_field = 'Field13'
phone_field = 'Field14'
location_selection_field = 'Field254'
location_names = { 'PDX' => 'Portland', 'SEA' => 'Seattle', 'WEB' => 'Online' }
location_fields = { 'Portland' => 'Field256', 'Seattle' => 'Field258', 'Online' => 'Field1323' }

over18_yes = 'Field774_0'
over18_no = 'Field774_1'
diploma_yes = 'Field775_0'
diploma_no = 'Field775_1'
international_yes = 'Field877_0'
international_no = 'Field877_1'
authorized_yes = 'Field1321_0'
authorized_no = 'Field1321_1'

describe 'form filling' do
  it 'fills out /sign-up form for first track (under 18)', js: true do
    track = CURRENT_TRACKS.first
    index = 0
    location = location_names[track.split[3]]
    visit "https://www.epicodus.com/sign-up"
    sleep 5
    page.within_frame('wufooFormz12e0pp21gzvlw1') do
      fill_in first_name_field, with: 'Test'
      fill_in last_name_field, with: "#{track}"
      fill_in email_field, with: "#{track.parameterize}@mortalwombat.net"
      fill_in phone_field, with: "#{index}#{index}#{index}-#{index+1}#{index+1}#{index+1}-#{index+2}#{index+2}#{index+2}#{index+2}"
      select location, from: location_selection_field
      select track, from: location_fields[location]
      choose(over18_yes, option: "Yes")
      choose(diploma_no, option: "No")
      choose(international_yes, option: "Yes")
      choose(authorized_yes, option: "Yes")
      click_button 'Sign up!'
      sleep 5
      expect(page).to have_content 'Thanks for signing up!'
    end
  end
end
