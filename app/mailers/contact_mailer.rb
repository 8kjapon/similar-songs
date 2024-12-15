class ContactMailer < ApplicationMailer
  def confirmation_email(contact)
    @user = contact.user
    @contact = contact
    mail(to: @user.email, subject: 'お問い合わせ内容の確認')
  end

  def notification_email(contact)
    @admin_email = User.where(role: 'admin').pluck(:email)
    @contact = contact
    mail(to: @admin_email, subject: '新しいお問い合わせがありました')
  end
end
