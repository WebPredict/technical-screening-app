class AddIsScoredToTestSubmission < ActiveRecord::Migration
  def change
    add_column :test_submissions, :is_scored, :boolean, default: false
    add_column :test_submissions, :start_time, :datetime
    add_column :test_submissions, :end_time, :datetime
  end
end
