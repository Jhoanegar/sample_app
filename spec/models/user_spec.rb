require 'spec_helper'

describe User do
  before { @user = User.new( name: 'Example User',
                            email: 'user@example.com' ,
                            password: 'foobar', 
                            password_confirmation: 'foobar') }

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  context 'when name is not present' do
    before { @user.name = '' }
    it { should_not be_valid }
  end
  
  describe 'email address with mixed case' do
    let (:mixed_case_email) { "Foo@ExAmPle.cOm" }

    its 'saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  context 'when name is too long' do
    before { @user.name = 'a'*51 }
    it { should_not be_valid }
  end

  context 'when password is not present' do
    before do
      @user.password = ""
      @user.password_confirmation = ""
    end

    it { should_not be_valid }
  end

  context 'when password doesn\'t match confirmation' do
    before do
      @user.password_confirmation = "mismatch"
    end

    it { should_not be_valid }
  end

  context 'when password is too short' do
    before { @user.password = @user.password_confirmation = 'a'*5 }
    it { should_not be_valid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email:@user.email) }

    context 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    context 'with invalid password' do
      let(:user_for_invalid_password) { found_user.
                                      authenticate( "invalid") } 
    
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false } 
    end
  end
      
  context 'when email is not present' do
    before { @user.email = '' }
    it { should_not be_valid  }
  end

  context 'when email format is invalid' do
    it 'should be invalid' do 
      addresses = %w[user@foo,com user_at_foo.org example.user@foo..c]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  context 'when email format is valid' do
    it 'should be valid' do 
      addresses = %w[user@foo.com user@oo.org example.user@FOO.COM]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  context 'when email is already taken' do
    before do 
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid } 
  end

  context 'when a previous email address exists in different case' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end
    
    it {should_not be_valid}
  end

    
  describe "remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

end
