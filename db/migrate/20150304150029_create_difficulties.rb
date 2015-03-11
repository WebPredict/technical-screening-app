class CreateDifficulties < ActiveRecord::Migration
  def change
    create_table :difficulties do |t|
      t.string :level

      t.timestamps null: false
    end
  end
end
