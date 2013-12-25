require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Sample App" }
  
  describe "Home Page" do

    it 'has the content "Sample App"' do
      visit root_path
      page.should have_content('Sample App')
    end

    it 'has the right base_title' do
      visit root_path
      page.should have_title("#{base_title}")
    end

    it "doesn't have a custom page title" do
      visit root_path
      page.should_not have_title("| Home")
    end
  end

  describe "Help page" do

    it 'has the content "Help"' do
      visit help_path
      page.should have_content('Help')
    end

    it 'has the right title' do
      visit help_path
      page.should have_title("#{base_title} | Help")
    end
  end

  describe "About page" do

    it 'has the content "About Us"' do
      visit about_path
      page.should have_content('About Us')
    end


    it 'has the right title' do
      visit about_path
      page.should have_title("#{base_title} | About")
    end
  end

  describe 'Contact page' do

    it 'has the content "Contact"' do
      visit about_path
      page.should have_content('Contact')
    end
    it 'has the right title' do
      visit contact_path
      page.should have_title("#{base_title} | Contact")
    end

  end


end

