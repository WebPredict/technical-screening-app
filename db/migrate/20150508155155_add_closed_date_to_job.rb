class AddClosedDateToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :ClosedDate, :datetime
  end
end
