class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      ContactMailer.confirmation_email(@contact).deliver_now
      ContactMailer.notification_email(@contact).deliver_now
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:message)
  end
end
