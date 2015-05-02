class AddSentToToTestSubmission < ActiveRecord::Migration
  def change
    add_column :test_submissions, :sent_to, :string
  end
end
