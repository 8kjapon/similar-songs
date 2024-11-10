# Ahoy(アクセス記録用Gem)の設定用モデル
module Ahoy
  class Event < ApplicationRecord
    include Ahoy::QueryMethods

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, optional: true
  end
end
