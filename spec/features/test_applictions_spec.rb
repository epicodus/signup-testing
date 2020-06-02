require 'rails_helper'

feature 'leads created when application filled out' do
  let(:close_io_client) { Closeio::Client.new(ENV['CLOSE_IO_API_KEY'], false) }
  let(:phone) { '+11234567890' }
  let(:email) { 'example.com' }
  let(:fields) {
    {
      'status_label': 'Applicant - Potential',
      'custom.lcf_ZD6EzawTf851IK6BqkKi9PugNKthpgjJotbNc9hMSAu': 'Yes',
      'custom.lcf_4qKJ9VGRB1DYjwFSOnrDBowHD4rxBT6KmS82HqU9uoQ': 'Yes',
      'custom.lcf_A6Wt06IbJVBIWiqgOKWveZjWmd1SJNrExmA6mFse0qT': 'Yes',
      'custom.lcf_qogMsgZA0BqO8EhNvX7ArkNqSteDR68to4YbYP9uqeX': 'Yes',
    }
  }

  scenario '/apply' do
    CURRENT_TRACKS.each_with_index do |track, index|
      location = track.split[3]
      location = 'Portland' if location == 'PDX'
      location = 'Seattle' if location == 'SEA'
      location = 'Online' if location == 'WEB'
      contact_name = "Automated Test"
      gclid = "test_gclid_#{index+1}"
      sqf_source = "test_sqf_source_#{index+1}"
      email = "automated-test-#{location.downcase}-#{index+1}@example.com"
      lead = close_io_client.list_leads('email:"' + email + '"')['data'].first
      expect(lead['custom.lcf_KWlZBYiqAZl99npZ48QxOR9OWtomdUtBhrDv3LALC85']).to_not eq nil # career services contact
      expect(lead['contacts'].first['name']).to eq contact_name
      expect(lead['contacts'].first['emails'].first['email']).to eq email
      expect(lead['contacts'].first['phones'].first['phone']).to eq phone
      fields.keys.each do |key|
        expect(lead[key.to_s]).to eq fields[key]
      end
      expect(lead['custom.lcf_GrOe1vSEWCpdfHpOaCiEchiYTzlGzg7HpL4rICb2bJh']).to eq track
      # don't check gclid & sqf_source, cuz squarespace intermittently fails to include them
      # expect(lead['custom.lcf_evscNi8u9X80uVkSZwQ9UOIZadoeewAVinWIpFIh0ST']).to eq gclid
      # expect(lead['custom.lcf_QwLH5hV1Nzu6Np0tT3GpnBoW4GhXmeOWO7SBJwIxUjc']).to eq sqf_source
      puts "PASSED /apply: #{track} (#{index+1})"
      close_io_client.delete_lead(lead['id'])
    end
  end
end
