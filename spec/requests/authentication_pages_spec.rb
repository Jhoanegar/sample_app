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
end
