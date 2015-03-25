class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :description
      t.string :website
    end
    
    add_reference :users, :company, index: true
  end
end
