require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  before { @user = FactoryGirl.build(:user) }
  
  it "is valid" do
    @user.valid?
    expect(@user).to be_valid
  end
  
  it "is invalid with a blank/no email" do
    @user.email = " "
    @user.valid?
    expect(@user.errors[:email]).to include("can't be blank")
  end
  
  it "is invalid without a proper email" do
    @user.email = "a"
    @user.valid?
    expect(@user.errors[:email]).to include("is invalid")
  end
  
  it "is invalid with a duplicate email" do
    @user.save
    @otheruser = FactoryGirl.build(:user)
    @otheruser.email = @user.email
    @otheruser.valid?
    expect(@otheruser.errors[:email]).to include("has already been taken")
  end
  
  it "is invalid without same password for password_confirmation" do
    @user.password_confirmation = "xxxxx"
    @user.valid?
    expect(@user.errors[:password_confirmation]).to include("doesn't match Password")
  end
  
  it "responds to auth_token" do
    # expect(@user.auth_token).to eq ""
    expect(@user).to respond_to(:auth_token)
  end
  
  it "is invalid without a duplicate auth_token" do
    @user.save
    @otheruser = FactoryGirl.build(:user)
    @otheruser.auth_token = @user.auth_token
    @otheruser.valid?
    expect(@otheruser.errors[:auth_token]).to include("has already been taken")
  end
  
  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end
  
  describe "#products association" do
    before do
      @user.save
      3.times { FactoryGirl.create :product, user: @user }
    end
    
    it "should have many products validation" do
      expect(@user.products.length).to be(3)
    end
    
    it "destroys the associated products on self destruct" do
      products = @user.products
      @user.destroy
      products.each do |p|
        expect(Product.find(p)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
  describe "#orders association" do
    before do
      @user.save
      3.times { FactoryGirl.create :order, user: @user }
    end
    
    it "should have many products validation" do
      expect(@user.orders.count).to be(3)
    end
    
    it "destroys the associated products on self destruct" do
      orders = @user.orders
      @user.destroy
      orders.each do |order|
        expect(Order.find(order)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
end
