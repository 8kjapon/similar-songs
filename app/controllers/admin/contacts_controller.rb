module Admin
  class ContactsController < BaseController
    layout 'admin'

    def index
      @contacts = Contact.includes(:user)
    end

    def edit
      @contact = Contact.find(params[:id])
    end

    def update
      @contact = Contact.find(params[:id])
      if @contact.update(contact_params)
        redirect_to admin_contacts_path, notice: "問い合わせ内容を更新しました"
      else
        flash.now[:alert] = "更新に失敗しました"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @contact = Contact.find(params[:id])
      @contact.destroy
      redirect_to admin_contacts_path, notice: "削除しました"
    end

    private

    def contact_params
      params.require(:contact).permit(:status)
    end
  end
end
