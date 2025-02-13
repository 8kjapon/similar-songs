# Ahoy(アクセス記録用Gem)の設定用モデル
module Ahoy
  class Visit < ApplicationRecord
    self.table_name = "ahoy_visits"

    has_many :events, class_name: "Ahoy::Event", dependent: :destroy
    belongs_to :user, optional: true
  end
end
