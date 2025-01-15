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
      ActiveRecord::Base.transaction do
        user = User.new(user_attributes)

        add_interests_to(user) if interests.length > 1
        add_skills_to(user) if skills.length > 1

        unless user.save
          errors.merge!(user.errors)
          raise ActiveRecord::Rollback
        end

        user
      end
    end

    def to_model
      User.new
    end

    private

    def add_interests_to(user)
      user_interests = Interest.where(name: interests)
      user.interests = user_interests
    end

    def add_skills_to(user)
      user_skills = Skill.where(name: skills)
      user.skills = user_skills
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
