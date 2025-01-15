FactoryBot.define do
  factory :interest do
    interests = [
      'Programming',
      'Web Development',
      'Machine Learning',
      'DevOps',
      'Mobile Development',
      'UI/UX Design',
      'Database Administration',
      'Cloud Computing',
      'Cybersecurity',
      'Artificial Intelligence'
    ].freeze

    sequence(:name) { |n| interests[n % interests.length] }
  end
end
