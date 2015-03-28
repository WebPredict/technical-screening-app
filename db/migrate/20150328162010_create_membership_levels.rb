class CreateMembershipLevels < ActiveRecord::Migration
  def change
    create_table :membership_levels do |t|
      t.string :name
    end
    
    add_reference :users, :membership_level, index: true
  end
end
