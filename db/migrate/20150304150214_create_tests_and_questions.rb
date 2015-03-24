class CreateTestsAndQuestions < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.string :description
      t.boolean :is_public, default: false
      t.references :user, index: true

      t.timestamps null: false
    end
    
    create_table :questions do |t|
      t.string :content
      t.string :answer
      t.references :user, index: true
      t.references :category, index: true
      t.references :difficulty, index: true

      t.timestamps null: false
    end

    create_table :questions_tests, id: false do |t|
      t.belongs_to :test, index: true
      t.belongs_to :question, index: true
    end
    
    add_foreign_key :tests, :users
    add_foreign_key :questions, :users
  end
end
