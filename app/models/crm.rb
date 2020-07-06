class Crm
  Rails.application.configure do
    config.x.crm_fields = config_for(:crm_fields)
    config.x.crm_ids = config_for(:crm_ids)
  end

  def initialize(track)
    @email = "#{track.parameterize}@mortalwombat.net"
  end

  def status
    lead.try('dig', 'status_label')
  end

  def cohort_applied
    lead.try('dig', Rails.application.config.x.crm_fields['COHORT_APPLIED'])
  end

  def cohort_starting
    lead.try('dig', Rails.application.config.x.crm_fields['COHORT_STARTING'])
  end

  def cohort_current
    lead.try('dig', Rails.application.config.x.crm_fields['COHORT_CURRENT'])
  end

  def cohort_parttime
    lead.try('dig', Rails.application.config.x.crm_fields['COHORT_PARTTIME'])
  end

  def invitation_token_present?
    lead.try('dig', Rails.application.config.x.crm_fields['INVITATION_TOKEN']).present?
  end

  def career_services_contact_pdx?
    user = lead.try('dig', Rails.application.config.x.crm_fields['CAREER_SERVICES_CONTACT'])
    user == Rails.application.config.x.crm_ids['USER_ELENA'] || user == Rails.application.config.x.crm_ids['USER_NINA']
  end

  def career_services_contact_sea_web?
    user = lead.try('dig', Rails.application.config.x.crm_fields['CAREER_SERVICES_CONTACT'])
    user == Rails.application.config.x.crm_ids['USER_CAMERON']
  end

  def received_email_assessment?
    sequence_subscriptions.include? Rails.application.config.x.crm_ids['SEQUENCE_EMAIL_ASSESSMENT']
  end

  def received_invitation?
    sequence_subscriptions.include? Rails.application.config.x.crm_ids['SEQUENCE_INVITATION']
  end

  def received_orientation_template?
    orientation_template['subject'].include? 'Epicodus Orientation'
  end

  def orientation_template_pdx?
    orientation_template['body_text'].include? '400 SW 6th Ave'
  end

  def orientation_template_sea?
    orientation_template['body_text'].include? '1402 3rd Avenue'
  end

  def orientation_template_web?
    orientation_template['body_text'].include? 'Discord'
  end

  def orientation_template_ft?
    orientation_template['body_text'].include? '8am'
  end

  def orientation_template_pt?
    orientation_template['body_text'].include?('5:30pm') || orientation_template['body_text'].include?('6pm')
  end

  def orientation_template_id_match?
    location = cohort_applied.split[3]
    if cohort_applied.include? 'Part-Time Intro to Programming'
      style = 'PT'
    elsif cohort_applied.include? 'JS/React'
      style = 'JS_REACT'
    else
      style = 'FT'
    end
    orientation_template['template_id'] == Rails.application.config.x.crm_ids["TEMPLATE_ORIENTATION_#{location}_#{style}"]
  end

  def scheduled_edi_template?
    emails_scheduled = email_templates.select {|e| e['status'] == 'scheduled'}
    emails_scheduled.map {|e| e['subject']}.include? 'Community at Epicodus'
  end

  def scheduled_discounts_template?
    emails_scheduled = email_templates.select {|e| e['status'] == 'scheduled'}
    emails_scheduled.map {|e| e['subject']}.include? 'Discounts for Epicodus Students'
  end

  def update(update_fields)
    close_io_client.update_lead(lead['id'], update_fields)
  end

private

  def lead
    @lead ||= close_io_client.list_leads('email: ' + @email)['data'].first
  end

  def close_io_client
    @close_io_client ||= Closeio::Client.new(ENV['CLOSE_IO_API_KEY'], false)
  end

  def career_services_contact
    lead.try('dig', Rails.application.config.x.crm_fields['CAREER_SERVICES_CONTACT'])
  end

  def sequence_subscriptions
    subscriptions = close_io_client.list_sequence_subscriptions(lead_id: lead['id'])['data']
    subscriptions.map {|subscription| subscription.try('dig', 'sequence_id')}
  end

  def email_templates
    close_io_client.list_emails(lead_id: lead['id'])['data'].reject {|e| e['sequence_subscription_id'].present? }
  end

  def orientation_template
    email_templates.select {|e| e['status'] == 'sent'}.first
  end
end
