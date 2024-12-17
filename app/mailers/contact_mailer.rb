class ContactMailer < ApplicationMailer
  def confirmation_email(contact)
    @user = contact.user
    @contact = contact
    mail(to: @user.email, subject: t("mailer.contact.confirmation_email.subject"))
  end

  def notification_email(contact)
    @admin_email = User.where(role: 'admin').pluck(:email)
    @contact = contact
    mail(to: @admin_email, subject: t("mailer.contact.notification_email.subject"))
  end
end
