class AddJobsReferenceToCandidate < ActiveRecord::Migration
  def change
    add_reference :candidates, :job, index: true
  end
end
