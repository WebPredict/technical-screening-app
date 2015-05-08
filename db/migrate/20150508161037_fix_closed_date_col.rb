class FixClosedDateCol < ActiveRecord::Migration
  def change
		rename_column :jobs, :ClosedDate, :closed_date
  end
end
