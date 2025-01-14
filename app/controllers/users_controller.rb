class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = Users::Create.new
    @skills = Skill.all
    @interests = Interest.all
  end

  def create
    outcome = Users::Create.run(params[:user])

    if outcome.valid?
      redirect_to users_path
    else
      @user = outcome

      render turbo_stream: turbo_stream.update('forms_errors',
                                               partial: 'shared/errors',
                                               locals:   { object: @user })
    end
  end
end
