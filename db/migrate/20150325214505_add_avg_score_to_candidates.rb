class AddAvgScoreToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :avg_score, :float, default: 0
  end
end
