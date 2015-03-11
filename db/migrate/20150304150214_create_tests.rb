class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.string :description
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :tests, :users
  end
end
