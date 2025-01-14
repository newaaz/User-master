class User < ApplicationRecord
  MIN_AGE = 0
  MAX_AGE = 90
  VALID_GENDERS = %w[male female]

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
end
