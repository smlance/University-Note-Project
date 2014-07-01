require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Sign up") }
    it { should have_title(full_title("Sign up")) }
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
        fill_in "Email", with: "usersss@examplesdds.com"
        fill_in "Password", with: "foobarss"
        fill_in "Confirmation", with: "foobarss"
      end
      # That (^) is all in the before block. It is valid information.

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    # This `user` corresponds to the same one FactoryGirl just created.

    describe "page" do
      # it { should == '' }
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    # The failing test
    describe "with invalid information" do
      before { click_button "Save changes" }
      # Try to save changes without filling in the edit form.

      it { should have_content('error') }
      # This "error" string would appear in the flash.
    end

    # The passing test
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
    # The above is upon arriving at the edit page;
    # the below is after the edits have been filled in and submitted
    # (???)

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "newsdss@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm password", with: user.password
        # The strings are case-sensitive!
        click_button "Save changes"
      end

      # After we have successfully saved the user

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
      # `reload` reloads the user var from the test db
    end

  end

  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user,
                                   content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user,
                                   content: "Bar") }

    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

end
