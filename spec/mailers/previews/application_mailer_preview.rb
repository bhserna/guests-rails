class ApplicationMailerPreview < ActionMailer::Preview
  def password_recovery_instructions
    ApplicationMailer.password_recovery_instructions(UserRecord.where.not(password_recovery_token: nil).first.id)
  end
end
