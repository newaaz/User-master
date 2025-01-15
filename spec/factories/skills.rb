FactoryBot.define do
  factory :skill do
    skills = [
      'Ruby',
      'Ruby on Rails',
      'PostgreSQL',
      'MySQL',
      'JavaScript',
      'React',
      'Vue.js',
      'Docker',
      'Git',
      'RSpec'
    ]

    sequence(:name) { |n| skills[n % skills.length] }
  end
end
