require 'rails_helper'

feature 'change lead statuses to enrolled' do
  scenario 'mark as enrolled' do
    CURRENT_TRACKS.each do |track|
      lead = Crm.new(track)
      lead.update({ status: "Enrolled" })
      puts "Updated status to Enrolled: #{track}"
    end
  end
end
