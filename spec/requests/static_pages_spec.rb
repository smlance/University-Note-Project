require 'spec_helper'

describe "Static Pages" do
  
  subject { page }
  # The subject is what is described in the below examples.

  describe "Home page" do
    before { visit root_path }
    # The stuff in the before block is done _before_ the rest
    # of the test.
    
    it { should have_content('note') }
    it { should have_title(full_title('Home')) }
    # The above diverges slightly from the tutorial,
    # as I did not include the refactoring that removes the
    # "| Home" from the root page's title.
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content("Help") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content("About") }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content("Contact")}
  end
end
