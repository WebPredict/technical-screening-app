class AddIsPublicToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_public, :boolean, default: true
  end
end
