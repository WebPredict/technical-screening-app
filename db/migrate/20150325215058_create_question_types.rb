class CreateQuestionTypes < ActiveRecord::Migration
  def change
    create_table :question_types do |t|
      t.string :name
    end
    
    add_reference :questions, :question_type, index: true
  end
end
