require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    # Go to the page we want to test first.
    # (Do this before running the test.)

    it { should have_content 'Sign in' }
    it { should have_title 'Sign in' }

  end

  describe "signin" do
    before { visit signin_path }

    # Failing test for signin
    describe "with invalid information" do
      before { click_button "Sign in" }
      # This is the failing test: we test signin failure
      # by hitting the sign in button without providing any
      # information about the user in the form.

      it { should have_title 'Sign in' }
      it { should have_selector 'div.alert.alert-error' }
      # It should have both of those selectors.

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector 'div.alert.alert-error' }
        # Go to some other page (we chose home) after the error
        # message has been flashed to confirm that the flash
        # disappears after one page render.
      end
    end

    # Passing test for signin
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      # Don't completely understand the above syntax. (???)
      before do
        fill_in "Email", with: user.email.upcase
        # We upcase the user password so that the search in the db
        # is case-insensitive.
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      # Note that after we hit the signin button with this valid
      # information, we get redirected to the page the user
      # goes to after signing in, so the below tests apply to that
      # page (since the valid signin applies in the `before` block).
      it { should have_title user.name }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link 'Sign in'}
        # If we have successfully signed out, then there should be a
        # link that allows us to sign in.
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signup_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end

      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
          # So, FG has created a user variable which we have access
          # to in this test. What is going on is that the test tries
          # to get us -- a person who has not yet signed in --
          # to visit the `edit` page for this particular user's
          # profile. It's important that we haven't yet signed in,
          # which we specify as necessary in some other tests
          # (e.g., check user_pages_spec.rb).
          # Hence, this is a failing test.
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        # An even stronger test -- if we try to bypass the page
        # and just submit a patch request* to the server, the server
        # knows we are not signed in, so it redirects us to the
        # signin page.
        # * for the user FG made above.
      end
    end
  end
  
end
