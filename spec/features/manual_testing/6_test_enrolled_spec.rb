require 'rails_helper'

feature 'sends orientation templates' do
  scenario 'check enrolled correctly' do
    CURRENT_TRACKS.each do |track|
      lead = Crm.new(track)
      expect(lead.status).to eq 'Enrolled'
      expect(lead.received_orientation_template?).to eq true
      expect(lead.orientation_template_id_match?).to eq true
      if track.include? 'Part-Time'
        expect(lead.orientation_template_pt?).to eq true
      else
        expect(lead.orientation_template_ft?).to eq true
      end
      if track.include? 'PDX'
        expect(lead.orientation_template_pdx?).to eq true
      elsif track.include? 'SEA'
        expect(lead.orientation_template_sea?).to eq true
      elsif track.include? 'WEB'
        expect(lead.orientation_template_web?).to eq true
      end
      expect(lead.scheduled_edi_template?).to eq true
      expect(lead.scheduled_discounts_template?).to eq true
      puts "Enrolled successfully: #{track}"
    end
  end
end
