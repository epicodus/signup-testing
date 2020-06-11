require 'rails_helper'

feature 'epicenter account created and sent invitation sequence' do
  scenario 'check accepted correctly' do
    CURRENT_TRACKS.each do |track|
      lead = Crm.new(track)
      expect(lead.status).to eq 'Applicant - Accepted'
      expect(lead.cohort_current).to eq track
      expect(lead.cohort_starting).to eq track
      expect(lead.invitation_token_present?).to eq true
      expect(lead.received_invitation?).to eq true
      puts "Invited successfully: #{track}"
    end
  end
end
