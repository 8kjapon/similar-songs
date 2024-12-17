class Contact < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, resolved: 1 }

  validates :message, presence: :true

  # 翻訳したステータス情報を取得する処理
  def status_i18n
    I18n.t("activerecord.attributes.contact.status.#{status}")
  end
end
