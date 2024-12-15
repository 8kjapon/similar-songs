class Contact < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, resolved: 1 }

  validates :message, presence: :true
end
