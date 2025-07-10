require 'faker'
puts "Seeding database..."

JobApplication.delete_all
Opportunity.delete_all
Client.delete_all
JobSeeker.delete_all

# Create Clients
10.times do
  Client.create!(name: Faker::Company.unique.name)
end
puts "Created #{Client.count} clients"

# Create Opportunities
Client.find_each do |client|
  rand(3..6).times do
    client.opportunities.create!(
      title: Faker::Job.title,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      salary: rand(50_000..150_000)
    )
  end
end
puts "Created #{Opportunity.count} opportunities"

# Create JobSeekers
20.times do
  JobSeeker.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end
puts "Created #{JobSeeker.count} job seekers"

# Create JobApplications
JobSeeker.find_each do |seeker|
  applied_opportunities = Opportunity.order("RANDOM()").limit(rand(1..3))
  applied_opportunities.each do |opp|
    JobApplication.create!(job_seeker: seeker, opportunity: opp)
  end
end
puts "Created #{JobApplication.count} job applications"
puts "Seeding complete!"

