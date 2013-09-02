require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "Login page" do
    before { visit login_path }

    it { should have_content('Login') }
    it { should have_title('Login') }

    it { should_not have_link('Logout',    href: logout_path) }
    it { should have_link('Login', href: login_path) }
    it { should have_link('Sign Up', href: signup_path) }
  end

  describe "login process" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Login" }


      it { should have_title('Login') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid username and password combination') }
    end
    
    describe "with valid information" do
      before do
      	fill_in "Email",        		with: user.email
	      fill_in "Password",     		with: user.password
      	click_button "Login" 
      end
      let(:user) { FactoryGirl.create(:user) }
  
  		it { current_path.should == "/users/#{user.id}" }
      it { should have_selector('div.alert.alert-success', text: "Welcome to APP NAME, #{user.first_name} #{user.last_name}!") }

      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link("Login") }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
    
      let(:user) { FactoryGirl.create(:user) }
    
      describe "in the Users controller" do
  
        describe "visiting the edit page" do
  
          before { visit edit_user_path(user) }
            it { should have_title('Login') }
        end

        describe "submitting to the update action" do
          
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(login_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Login') }
        end
      end
    end

    describe "as wrong user" do
      
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      
      describe "visiting Users#edit page" do
        before { login user; visit edit_user_path(wrong_user) }
        it { should_not have_title('Update your profile') }
      end
    end
  end
end