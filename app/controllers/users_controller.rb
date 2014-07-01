class UsersController < ApplicationController

  # Before filters
  # (`before_action`s _are_ before filters.)

  before_action :signed_in_user, only: [:index, :edit, :update,
                                        :destroy]
  # This before filter ensures that the user must be signed
  # in before issuing an edit, index, destroy, or update request.
  # (See the signed_in_user method below.)

  before_action :correct_user, only: [:edit, :update]
  # Ensures that any particular user can only edit _his_
  # profile.

  before_action :admin_user, only: :destroy

  def index
    # Show all users on the page we obtained from the pagination
    # hash.
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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

  def edit
    @user = User.find(params[:id])
  end

  def update

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      # We did not successfully update the user, so re-render
      # the edit page.
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      # Gets the necessary parameters from the user post request.
      # Protects against mass assignment via not returning an
      # exposed (public) user hash.
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
      # (Strong parameters. These are the only ones that a user
      # can edit.)
    end

    # Before filters

    # singed_in_user is now in helpers/sessions_helper.rb

    def correct_user
      @user = User.find(params[:id])
      # Note that the params are obtained from the request?
      redirect_to(root_url) unless current_user?(@user)
      # Grabs the user identified by the params via the request the
      # browser made. If the browser is _not_ the current user, we
      # get redirected to the root url.
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
