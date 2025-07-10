require 'rails_helper'

RSpec.describe JobSeeker, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :job_applications }
  end

  describe 'validations' do
    subject do
      JobSeeker.create!(
        name: Faker::Name.name,
        email: Faker::Internet.unique.email
      )
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
