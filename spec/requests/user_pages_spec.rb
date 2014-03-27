require 'spec_helper'

describe "User pages" do
  
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Sign up") }
    it { should have_title(full_title("Sign up")) }

    let(:submit) { "Create my account" }

    context 'with invalid email' do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it 'doesn\'t create user' do
        expect{ click_button submit }.not_to change(User, :count)
      end
    end

    context 'with valid information' do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it 'creates user' do
        expect{ click_button submit }.to change(User, :count).by(1)
      end

      context 'after creating the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success',
                                  text: 'Welcome') }
        context 'followed by sign out' do
          before { click_link "Sign out" }
          it { should have_link "Sign in" }
        end
      end

    end
  end
 
  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

end
