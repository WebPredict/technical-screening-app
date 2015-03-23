class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :test_digest
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :candidates, :users
  end
end
