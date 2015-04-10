class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :description
      t.string :manager
      t.string :phone
      t.references :user, index: true
    end
    
    create_table :jobs_candidates, id: false do |t|
      t.belongs_to :candidate, index: true
      t.belongs_to :job, index: true
    end
  end
end
