module Users
  class Create < ActiveInteraction::Base
    set_callback :filter, :before, -> { email.downcase! if email.present? }

    string :name, :surname, :patronymic, :email, :nationality, :country, :gender
    integer :age
    array :interests, default: []
    array :skills, default: []

    validates :name, :surname, :patronymic, :email, :nationality, :country, :gender, presence: true
    validates :gender, inclusion: { in: User::VALID_GENDERS }
    validates :age, presence: true, numericality: { greater_than: User::MIN_AGE, less_than_or_equal_to: User::MAX_AGE }
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate  :email_uniqueness

    def execute
      User.transaction do
        user = User.create(user_attributes)

        add_interests_to(user) if interests.length > 1
        add_skills_to(user) if skills.length > 1

        user
      end
    end

    private

    def add_interests_to(user)
      interest_ids = Interest.where(name: interests).pluck(:id)

      user_interest_data = interest_ids.map do |interest_id|
        { user_id: user.id, interest_id: interest_id }
      end

      UserInterest.insert_all(user_interest_data)
    end

    def add_skills_to(user)
      skill_ids = Skill.where(name: skills).pluck(:id)

      user_skill_data = skill_ids.map do |skill_id|
        { user_id: user.id, skill_id: skill_id }
      end

      UserSkill.insert_all(user_skill_data)
    end

    def user_attributes
      {
        name: name,
        surname: surname,
        patronymic: patronymic,
        email: email,
        age: age,
        nationality: nationality,
        country: country,
        gender: gender,
        full_name: generate_full_name
      }
    end

    def generate_full_name
      "#{surname} #{name} #{patronymic}".strip
    end

    def email_uniqueness
      if User.exists?(email: email)
        errors.add(:email, :taken, message: 'has already been taken')
      end
    end
  end
end
