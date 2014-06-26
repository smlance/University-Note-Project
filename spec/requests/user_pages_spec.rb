require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Sign up") }
    it { should have_title(full_title("Sign up")) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }
    # Here, `let` defines a variable that we later use in this test.
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
        # That is, it's invalid when we don't include any user information
        # in the form.
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobarss"
        fill_in "Confirmation", with: "foobarss"
      end
      # That (^) is all in the before block. It is valid information.

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end
