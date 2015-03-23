class CreateAnsweredQuestions < ActiveRecord::Migration
  def change
    create_table :answered_questions do |t|
      t.string :answer
      t.boolean :correct
      t.references :question, index: true
      t.references :candidate, index: true

      t.timestamps null: false
    end
    add_foreign_key :answered_questions, :questions
    add_foreign_key :answered_questions, :candidates
  end
end
