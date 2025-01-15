require 'rails_helper'

feature 'Guest can create user' do

  describe 'Guest tries to create user' do
    given(:user_attributes) { attributes_for(:user) }

    # background { visit new_user_path }

    scenario 'with valid data' do
      visit new_user_path

      fill_in 'Name',        with: user_attributes[:name]
      fill_in 'Surname',     with: user_attributes[:surname]
      fill_in 'Patronymic',  with: user_attributes[:patronymic]
      fill_in 'Email',       with: user_attributes[:email]
      fill_in 'Age',         with: user_attributes[:age]
      fill_in 'Nationality', with: user_attributes[:nationality]
      fill_in 'Country',     with: user_attributes[:country]
      select 'male',         from: 'Gender'

      click_on 'Create User'

      expect(page).to have_content 'User created successfully'
      expect(page).to have_content "#{user_attributes[:name]} (#{user_attributes[:email]})"
      expect(page).to have_content 'Interests: 0'
      expect(page).to have_content 'Skills: 0'
    end

    scenario 'with skills and interests' do
      skills = create_list(:skill, 3)
      interests = create_list(:interest, 3)

      visit new_user_path

      fill_in 'Name',        with: user_attributes[:name]
      fill_in 'Surname',     with: user_attributes[:surname]
      fill_in 'Patronymic',  with: user_attributes[:patronymic]
      fill_in 'Email',       with: user_attributes[:email]
      fill_in 'Age',         with: user_attributes[:age]
      fill_in 'Nationality', with: user_attributes[:nationality]
      fill_in 'Country',     with: user_attributes[:country]
      select 'male',         from: 'Gender'

      page.check skills[0].name
      page.check skills[1].name
      page.check interests[0].name
      page.check interests[1].name

      click_on 'Create User'

      expect(page).to have_content 'Interests: 2'
      expect(page).to have_content 'Skills: 2'
    end

    scenario 'without required fields' do
      visit new_user_path

      fill_in 'Age', with: user_attributes[:age]
      click_on 'Create User'

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Surname can't be blank"
      expect(page).to have_content "Patronymic can't be blank"
      expect(page).to have_content "Nationality can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Email is invalid"
      expect(page).to have_content "Country can't be blank"
    end

    scenario 'without age' do
      visit new_user_path

      click_on 'Create User'

      expect(page).to have_content 'Age is required'
    end

    scenario 'with age less than 0' do
      visit new_user_path

      fill_in 'Age', with: -1
      click_on 'Create User'

      expect(page).to have_content 'Age must be greater than 0'
    end

    scenario 'with age greater than 90' do
      visit new_user_path

      fill_in 'Age', with: 91
      click_on 'Create User'

      expect(page).to have_content 'Age must be less than or equal to 90'
    end

    scenario 'with existed user' do
      user = create(:user)

      visit new_user_path

      fill_in 'Name',        with: user.name
      fill_in 'Surname',     with: user.surname
      fill_in 'Patronymic',  with: user.patronymic
      fill_in 'Email',       with: user.email
      fill_in 'Age',         with: user.age
      fill_in 'Nationality', with: user.nationality
      fill_in 'Country',     with: user.country
      select 'male',         from: 'Gender'

      click_on 'Create User'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
