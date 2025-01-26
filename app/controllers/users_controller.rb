class UsersController < ApplicationController
  def index
    @users = User.includes(:skills, :interests).all
  end

  def new
    @user = User.new
    @skills = Skill.all
    @interests = Interest.all
  end

  def create
    outcome = Users::Create.run(params[:user])

    if outcome.valid?
      redirect_to users_path, notice: 'User created successfully'
    else
      @user = outcome
      @skills = Skill.all
      @interests = Interest.all

      respond_to do |format|
        format.html { render 'new', status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.update('forms_errors',
                                       partial: 'shared/errors',
                                       locals:   { object: @user })
        end
      end
    end
  end
end
