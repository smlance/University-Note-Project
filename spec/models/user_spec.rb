require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User",
                     email: "Foofdfd@Bddfdfar.com",
                     password: "foobarss",
                     password_confirmation: "foobarss")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should be_valid }
  # What we provided above / did above in the before block
  # should be valid.

  describe "when name is not present" do
    # Failing test.
    before { @user.name = " " }
    it { should_not be_valid }
    # Note: "Whenever an object responds to a boolean method
    # `foo?`, there is a corresponding test method `be_foo`."
    # (http://www.railstutorial.org/book/modeling_users)
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be vallid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    # Define :found_user by looking in the db for the user with the
    # email given. (This is what `let` does.)
    # `let` creates local variables inside tests (it can do this.)

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      # Because `let` memoizes its value, it only hits the db once,
      # so the `let` here does not (since this is a nested `describe`
      # block).

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
      # `specify` does exactly the same thing that `it` does.
      # We just determine what to use based on what is semantically
      # more pleasing.
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid}
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    # The above line is equivalent to:
    # `it { expect(@user.remember_token).not_to be_blank }`
    # because of the `its` method.
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    # Note that let is lazy-evaluated: it is not evaluated until the first time
    # the method it defines is invoked. You can use let! to force the method's
    # invocation before each example.'
    # (https://www.relishapp.com/rspec/rspec-core/docs/helper-methods/let-and-let)

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      # The `to_a` ensures that even after we destroy the user from
      # the database, the array contains the once-existing microposts.
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end

end
