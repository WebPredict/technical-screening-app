class CreateNote < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :content
      t.references :candidate, index: true
    end
  end
end
