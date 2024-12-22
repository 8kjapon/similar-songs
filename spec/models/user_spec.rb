require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ユーザー名、メールアドレスが必須項目になっているか' do
    user = build(:user)
    user.name = nil
    user.email = nil
    user.valid?
    expect(user.errors[:name]).to include('ユーザー名が入力されていません')
    expect(user.errors[:email]).to include('メールアドレスが入力されていません')
  end

  it 'ユーザー名が2文字以上であれば有効になるか' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'ユーザー名が255文字以下制限であるか' do
    user = build(:user)
    user.name = 'a' * 256
    user.valid?
    expect(user.errors[:name]).to include('ユーザー名は255文字以内で入力してください')
  end

  it 'メールアドレスがユニークであるか' do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include('メールアドレスは既に存在します')
  end
end
