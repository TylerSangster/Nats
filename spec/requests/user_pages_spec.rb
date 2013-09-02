require 'spec_helper'

describe "UserPages" do

  subject { page }
  
  describe "signup page" do
    before { visit signup_path }

    it { should have_title('Sign up') }

    describe "fill out form incorrectly" do
      it "should not create a user" do
        expect { click_button "Create Account" }.not_to change(User, :count)
      end

      describe "after submission" do
          before { click_button "Create Account" }

          it { should have_title('Sign up') }
          it { should have_content('error') }
      end
    end


    describe "fill out form" do
      before do
        fill_in "First Name",       with: "Tyler"
        fill_in "Last Name",        with: "Sangster"
        fill_in "Email",            with: "tyler.sangster@gmail.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should increment user count" do
        expect { click_button "Create Account" }.to change(User,:count).by(1)
      end

      describe "should display welcome message" do
        before { click_button "Create Account";}
        let(:user) { FactoryGirl.build(:user) }

        it { should have_title("#{user.first_name} #{user.last_name}") }
        
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end#signup

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      login user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Update your profile") }
    end

    describe "with invalid information" do
      before { click_button "Save Changes" }

      it { should have_title("Update your profile") }
      it { should have_content("error") }
    end

    describe "with valid information" do
      let(:new_first_name)  { "Sam" }
      let(:new_last_name)  { "Powersampower" }
      let(:new_email) { "samkpower@example.com" }
      before do
        fill_in "First Name",       with: new_first_name
        fill_in "Last Name",        with: new_last_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save Changes"
      end


      it { should have_title("#{new_first_name} #{new_last_name}") }
      it { should have_selector('div.alert.alert-success') }

      specify { expect(user.reload.first_name).to  eq new_first_name }
      specify { expect(user.reload.last_name).to  eq new_last_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end#edit

  describe "index" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:user_two) { FactoryGirl.create(:user_two) }
    let!(:admin_user) { FactoryGirl.create(:admin_user) }
    before(:each) do
      login user_two
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }

    it { should have_content(user.first_name) }
    it { should have_content(user.last_name) }
    it { should have_content(user.email) }
    
    it { should have_link('edit', href: edit_user_path(user)) }

    describe "delete links" do
      it { should_not have_link('delete') }
      
      describe "as admin user" do
        before { login admin_user; visit users_path }
        it { should have_link('delete', href: user_path(User.first)) }

        it "should be able to delete user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin_user)) }
      end
    end
  end#index
end



# edit user profile
# show user profile
# delete user profile


# only admin can:
# => delete users other than him
# => see users#index

# LATER:
# => check that creating a new user profile automatically signs in
# => profile page should contain reviews



