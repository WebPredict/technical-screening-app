class AddTimestampToNotes < ActiveRecord::Migration
  def change
      add_column(:notes, :created_at, :datetime)
      add_column(:notes, :updated_at, :datetime)  
  end
end
