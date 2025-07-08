class CreateJobApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :job_applications do |t|
      t.references :job_seeker, null: false, foreign_key: true
      t.references :opportunity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
