class Mailer < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = "localpolitics.in"

  def twitter_invite(congress_person, args = {})
    recipients congress_person.email_address
    from       args[:from]
    subject    args[:subject]
    citizen_name = args[:citizen_name] || "A citizen"
    body       :congress_person => congress_person, :personal_message => args[:personal_message], :citizen_name => citizen_name, :invitation_text => Tweet.invitation_text
  end

end
