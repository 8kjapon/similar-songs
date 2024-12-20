class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.text :message
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
