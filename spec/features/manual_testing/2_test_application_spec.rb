require 'rails_helper'

feature 'leads created when application filled out' do
  scenario 'check applicants made it into close' do
    CURRENT_TRACKS.each do |track|
      lead = Crm.new(track)
      expect(lead.status).to eq 'Applicant - Potential'
      expect(lead.cohort_applied).to eq track
      if track.include? 'PDX'
        expect(lead.career_services_contact_pdx?).to eq true
      else
        expect(lead.career_services_contact_sea_web?).to eq true
      end
      expect(lead.received_email_assessment?).to eq true
      puts "Wufoo -> Close successful: #{track}"
    end
  end
end
