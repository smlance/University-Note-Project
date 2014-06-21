class SessionsController < ApplicationController

  def new
  end

  def create
    # Find the user in the database by looking up via the 
    # password given in the params hash (obtained from the
    # form submission)
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      # Sign in successful
      sign_in user
      redirect_back_or user
      # If the user tried to get somewhere originally because he
      # wasn't signed in, then bring him back there; otherwise,
      # just take him to his profile page.
    else
      # Sign in unsuccessful
      # Use `flash.now` to make the flash persist only for the 
      # newly rendered / rerendered page rather than until a new
      # request is submitted, which is what `flash` normally does.
      flash.now[:error] = 'Invalid email and password combination'
      # (We are only rerendering a page, not submitting a CRUD
      # request.)
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
