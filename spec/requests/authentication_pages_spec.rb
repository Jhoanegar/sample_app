require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    
    context 'when singing in' do
      context 'with invalid information' do

        before { click_button 'Sign in' }

        it { should have_title 'Sign in' }
        it { should have_error_message('Invalid') } 

        context 'after visiting another page' do
          before { click_link 'Home' }
          it { should_not have_error_message('Invalid') } 
        end
      end

      context 'with valid information' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          valid_signin(user)
        end

        it { should have_title(user.name) }
        it { should have_link('Profile', href:user_path(user)) }
        it { should have_link('Settings', href: edit_user_path(user)) }
        it { should have_link('Sign out', href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }

      end
    end
  end

  describe "authorization" do
    context "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      context "in the users controller" do
        context "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { should have_title('Sign in') }
          it { should have_warning_message('Please sign in.') }
        end

        context 'visiting the index page' do
          before { visit users_path }
          it { should have_titl('Sign in') }
        end

        context 'submitting to the update action' do
          before { patch user_path(user) }
          
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      context 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        context 'after signing in' do
          it 'renders the desired protected page' do
            expect(page).to have_title "Edit user"
          end
        end
      end
    end

    context 'as a wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user,
                          email: 'wrong@email.com') }
      before { sign_in user, no_capybara: true }

      context 'submitting a GET request to the User#edit action' do
        before { get edit_user_path(wrong_user) }

        specify { expect(response.body).
                      not_to match(full_title('Edit')) }
        specify { expect(response).to redirect_to(root_url) }

      end
    end
  end
end
