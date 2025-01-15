require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  describe '#execute' do
    let(:params) { attributes_for(:user) }

    subject(:context) { Users::Create.run(params) }

    context 'with valid params' do
      it 'saves new user in DB' do
        expect { context }.to change(User, :count).by(1)
      end

      it 'successful result' do
        expect(context).to be_a_valid
      end

      it 'creates a user with correct attributes' do
        user = context.result

        expect(user.email).to eq(params[:email])
        expect(user.name).to eq(params[:name])
        expect(user.age).to eq(params[:age])
        expect(user.full_name).to eq("#{params[:surname]} #{params[:name]} #{params[:patronymic]}")
      end

      it 'creates a new user with skills and interests' do
        skills = create_list(:skill, 3)
        interests = create_list(:interest, 3)

        params['skills'] = skills.map(&:name)
        params['interests'] = interests.map(&:name)

        user = context.result

        expect(user.skills).to match_array(skills)
        expect(user.interests).to match_array(interests)
      end

      it 'creates a new user without skills and interests' do
        user = context.result

        expect(user.skills).to be_empty
        expect(user.interests).to be_empty
      end

      it 'converts email to lowercase' do
        params[:email] = 'User@Example.Com'
        user = context.result
        expect(user.email).to eq('user@example.com')
      end
    end

    context 'with invalid params' do
      context 'when required fields are missing' do
        let(:params) { attributes_for(:user).slice(:age) }

        it 'fails' do
          expect(context).to be_invalid
        end

        it 'returns errors for required fields' do
          context
          expect(context.errors[:name]).to include("is required")
          expect(context.errors[:patronymic]).to include("is required")
          expect(context.errors[:nationality]).to include("is required")
          expect(context.errors[:country]).to include("is required")
          expect(context.errors[:gender]).to include("is required")
          expect(context.errors[:email]).to include("is required")
        end
      end

      context 'when email validation fails' do
        it 'returns error when email is blank' do
          outcome = Users::Create.run(params.merge(email: nil))
          expect(outcome.errors[:email]).to include("is required")
        end

        it 'returns error when email format is invalid' do
          outcome = Users::Create.run(params.merge(email: 'invalid_email'))
          expect(outcome.errors[:email]).to include("is invalid")
        end

        it 'returns error when email is already taken' do
          existing_user = create(:user)
          outcome = Users::Create.run(params.merge(email: existing_user.email))
          expect(outcome.errors[:email]).to include("has already been taken")
        end
      end

      context 'when age validation fails' do
        it 'returns error when age is not a number' do
          outcome = Users::Create.run(params.merge(age: 'invalid_age'))
          expect(outcome.errors[:age]).to include("is not a valid integer")
        end

        it 'returns error when age is less than 0' do
          outcome = Users::Create.run(params.merge(age: -1))
          expect(outcome.errors[:age]).to include("must be greater than 0")
        end

        it 'returns error when age is greater than 90' do
          outcome = Users::Create.run(params.merge(age: 91))
          expect(outcome.errors[:age]).to include("must be less than or equal to 90")
        end
      end

      context 'when gender validation fails' do
        it 'returns error when gender is invalid' do
          outcome = Users::Create.run(params.merge(gender: 'invalid_gender'))
          expect(outcome.errors[:gender]).to include("is not included in the list")
        end
      end
    end
  end
end
