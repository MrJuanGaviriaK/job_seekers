class JobApplication < ApplicationRecord
  belongs_to :job_seeker
  belongs_to :opportunity
  validates :job_seeker_id, uniqueness: { scope: :opportunity_id }
end
