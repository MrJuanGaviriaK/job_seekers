class Opportunity < ApplicationRecord
  belongs_to :client
  has_many :job_applications, dependent: :destroy

  validates :title, :description, :salary, presence: true
end
