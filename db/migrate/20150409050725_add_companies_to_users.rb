class AddCompaniesToUsers < ActiveRecord::Migration
  def change
  
    add_reference :companies, :user, index: true
    add_column :companies, :address, :string
    add_column :companies, :email, :string
    add_column :companies, :manager, :string
    add_column :companies, :phone, :string

    create_table :companies_users, id: false do |t|
      t.belongs_to :company, index: true
      t.belongs_to :user, index: true
    end
    
  end
end
