class CreateTestSubmissions < ActiveRecord::Migration
  def change
    create_table :test_submissions do |t|
      t.string :name
      t.integer :score, default: 0
      t.integer :duration
      t.references :user, index: true
      t.references :candidate, index: true
      t.references :test, index: true

      t.timestamps null: false
    end
    add_foreign_key :test_submissions, :users
    add_foreign_key :test_submissions, :candidates
    add_foreign_key :test_submissions, :tests
  end
end
