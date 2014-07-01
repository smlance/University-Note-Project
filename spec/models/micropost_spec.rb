require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  # Building the micropost automatically creates one that belongs
  # to the user with the appropriate user_id (user.id) and
  # returns it. So we do not have to directly use `create` or
  # `new` or reference the user_id.

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  its(:user) { should eq user }
  # The user that owns the micropost should be the same user
  # which FG just created for us.
  # (????) when could this test possibly go wrong? (????)

  it { should be_valid }
  # Note that `it` always refers to what we called the subject.

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " "}
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
