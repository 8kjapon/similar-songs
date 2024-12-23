require 'rails_helper'

RSpec.describe Contact, type: :model do
  it '問い合わせ内容が必須項目になっているか' do
    contact = build(:contact)
    contact.message = nil
    contact.valid?
    expect(contact.errors[:message]).to include('お問い合わせ内容が入力されていません')
  end
end
