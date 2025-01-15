require 'rails_helper'

RSpec.describe UsersController, type: :controller do


  describe 'POST #create' do
    let(:user_params) { attributes_for(:user) }

    context 'with valid params' do
      it 'saves new user in DB' do
        expect { post :create, params: { user: user_params } }.to change(User, :count).by(1)
      end

      it 'creates user with correct attributes' do
        post :create, params: { user: user_params }

        user = User.find_by(email: user_params[:email])

        expect(user.email).to eq(user_params[:email])
        expect(user.name).to eq(user_params[:name])
        expect(user.surname).to eq(user_params[:surname])
        expect(user.patronymic).to eq(user_params[:patronymic])
        expect(user.nationality).to eq(user_params[:nationality])
        expect(user.country).to eq(user_params[:country])
        expect(user.gender).to eq(user_params[:gender])
        expect(user.age).to eq(user_params[:age])
        expect(user.full_name).to eq("#{user_params[:surname]} #{user_params[:name]} #{user_params[:patronymic]}")
      end

      it 'redirect to the users page' do
        post :create, params: { user: user_params }
        expect(response).to redirect_to users_path
      end

      it 'creates a new user without skills and interests' do
        post :create, params: { user: user_params }

        user = User.find_by(email: user_params[:email])

        expect(user.skills).to be_empty
        expect(user.interests).to be_empty
      end

      it 'creates a new user with skills and interests' do
        skills = create_list(:skill, 3)
        interests = create_list(:interest, 3)

        user_params['skills'] = skills.map(&:name)
        user_params['interests'] = interests.map(&:name)

        post :create, params: { user: user_params }

        user = User.find_by(email: user_params[:email])

        expect(user.skills).to eq skills
        expect(user.interests).to eq interests
      end
    end

    context 'with invalid params' do
      it 'does not save new user in DB' do
        expect { post :create, params: { user: attributes_for(:user, name: nil) } }.to_not change(User, :count)
      end

      it 'renders error template' do
        post :create, params: { user: attributes_for(:user, name: nil) }
        expect(response).to render_template :new
      end

      it 'getting an errors with missing required fields (name, patronymic, male, nationality, country, gender)' do
        post :create, params: { user: attributes_for(:user).slice(:age) }

        expect(assigns(:user).errors[:name]).to include("is required")
        expect(assigns(:user).errors[:patronymic]).to include("is required")
        expect(assigns(:user).errors[:nationality]).to include("is required")
        expect(assigns(:user).errors[:country]).to include("is required")
        expect(assigns(:user).errors[:gender]).to include("is required")
        expect(assigns(:user).errors[:email]).to include("is required")
      end

      it 'getting an error - email can not blank' do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(assigns(:user).errors[:email]).to include("can't be blank")
      end

      it 'getting an error - email is not valid' do
        post :create, params: { user: attributes_for(:user, email: 'invalid_email') }
        expect(assigns(:user).errors[:email]).to include("is invalid")
      end

      it 'getting an error - email is already taken' do
        user = create(:user)
        post :create, params: { user: attributes_for(:user, email: user.email) }
        expect(assigns(:user).errors[:email]).to include("has already been taken")
      end

      it 'getting an error - age is not a number' do
        post :create, params: { user: attributes_for(:user, age: 'invalid_age') }
        expect(assigns(:user).errors[:age]).to include("is not a valid integer")
      end

      it 'getting an error - age must be greater than 0' do
        post :create, params: { user: attributes_for(:user, age: -1) }
        expect(assigns(:user).errors[:age]).to include("must be greater than 0")
      end

      it 'getting an error - age must be less than 90' do
        post :create, params: { user: attributes_for(:user, age: 91) }
        expect(assigns(:user).errors[:age]).to include("must be less than or equal to 90")
      end

      it 'gender must be male or female' do
        post :create, params: { user: attributes_for(:user, gender: 'invalid_gender') }
        expect(assigns(:user).errors[:gender]).to include("is not included in the list")
      end

      it 'getting an error - skills, interests must be an array' do
        post :create, params: { user: attributes_for(:user, skills: 'skills', interests: 'interests') }
        expect(assigns(:user).errors[:skills]).to include("is not a valid array")
      end
    end
  end
end
