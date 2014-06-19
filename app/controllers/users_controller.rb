class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

      # If the user's information successfully saves to the db,
      # direct the user to the User show action (the user's profile
      # page).
      #
      # The flash hash is universal (?) (accessible by the view),
      # and by setting the :success key to have a non-nil value
      # before redirecting to the user action, we allow the flash
      # message to be rendered in the view.

      # Sign the user in upon creation (makes a new session)
      sign_in @user
      flash[:success] = "Welcome to U-Note!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private


    def user_params
      # Gets the necessary parameters from the user post request.
      # Protects against mass assignment via not returning an
      # exposed (public) user hash.
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
