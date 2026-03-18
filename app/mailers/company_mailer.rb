class CompanyMailer < ApplicationMailer
  def invitation_email(user, temp_password)
    @user = user
    @password = temp_password
    @url = "http://localhost:3000/diligences"

    mail(to: @user.email_address, subject: "Acesso ao Sistema de Compliance - ISM")
  end
end
