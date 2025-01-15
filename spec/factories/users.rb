FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@mail.ru" }
    name        { "John" }
    surname     { "Doe" }
    patronymic  { "Smith" }
    nationality { "American" }
    country     { "USA" }
    gender      { "male" }
    age         { 25 }

    after(:build) do |user|
      user.full_name = "#{user.surname} #{user.name} #{user.patronymic}"
    end

    trait :with_skills do
      after(:create) do |user|
        skills = create_list(:skill, 2)
        user.skills = skills
        user.save
      end
    end

    trait :with_interests do
      after(:create) do |user|
        interests = create_list(:interest, 2)
        interests.each do |interest|
          create(:user_interest, user: user, interest: interest)
        end
      end
    end

    trait :with_skills_and_interests do
      with_skills
      with_interests
    end
  end
end
