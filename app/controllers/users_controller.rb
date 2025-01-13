class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
    @skills = Skill.all
    @interests = Interest.all
  end

  def create
    user_full_name = "#{user_params['surname']} #{user_params['name']} #{user_params['patronymic']}"

    @user = User.new(user_params.merge(full_name: user_full_name))

    if @user.save
      redirect_to users_path
    else
      @skill = Skill.all
      @interests = Interest.all

      flash.now[:alert] = outcome.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :surname,
      :patronymic,
      :email,
      :age,
      :nationality,
      :country,
      :gender,
      interest_ids: [],
      skill_ids: []
    )
  end
end
