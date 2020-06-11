require 'rails_helper'

feature 'change lead statuses to applicant - accepted' do
  scenario 'mark as accepted' do
    CURRENT_TRACKS.each do |track|
      lead = Crm.new(track)
      lead.update({ status: "Applicant - Accepted" })
      puts "Updated status to Applicant - Accepted: #{track}"
    end
  end
end
