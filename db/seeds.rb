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
  'RSpec',
]

Skill.destroy_all
Skill.create!(skills.map { |skill| { name: skill } })

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
]

Interest.destroy_all
Interest.create!(interests.map { |interest| { name: interest } })

puts "Seeds created successfully!"
