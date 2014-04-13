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
 
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_title("Edit user") }
      it { should have_content("Update your profile") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    context 'with invalid information' do
      before { click_button 'Save changes' }
      it { should have_error_message('error') }
    end

    context 'with valid information' do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@email.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_title(new_name) }
      it { should have_success_message('updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end 
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ted", email: "ted@example.com")
      visit users_path
    end

    it { should have_title "All users" }
    it { should have_content "All users" }

    it 'lists every user' do
      User.all.each do |user|
        expect(page).to have_content(user.name)
      end
    end
  end
      
end
