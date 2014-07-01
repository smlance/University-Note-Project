class MicropostsController < ApplicationController

  before_action :signed_in_user
  # Note that we do not need to say `, only: [:create, :destroy]`
  # because these are the only micropost actions we have defined.
  # If we had another action here, we would need the only qualification.

  def create
    @micropost = current_user.microposts.build(micropost_params)
    # Use of strong parameters here with building the params in
    # a private function rather than passing in the whole hash.
    if @micropost.save
      flash[:success] = "Micropost created!"
      # This if statement does attempt to save the micropost to
      # the database within the test itself.
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
  # end private
end
