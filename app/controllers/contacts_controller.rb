class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      ContactMailer.confirmation_email(@contact).deliver_now
      ContactMailer.notification_email(@contact).deliver_now
      redirect_to root_path, notice: t("views.flash_message.notice.contacts")
    else
      flash.now[:alert] = t("views.flash_message.alert.contacts")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:message)
  end
end
