module Lists
  class Mailer
    def send_access_given_notification(person_id)
      ApplicationMailer.access_given_notification(person_id).deliver
    end
  end
end
