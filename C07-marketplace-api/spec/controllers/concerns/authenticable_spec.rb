require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

RSpec.describe Authenticable do
  let(:authentication) { Authentication.new } # let - it's like variable
  
  subject { authentication } # subject means Object to test on
  
  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
      # authentication.stub(:request).and_return(request)
      allow(authentication).to receive(:request).and_return(request)
    end
    
    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
    
  end
  
  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user
      # authentication.stub(:current_user).and_return(nil)
      allow(authentication).to receive(:current_user).and_return(nil)
      #response.stub(:response_code).and_return(401)
      allow(response).to receive(:status).and_return(401)
      #response.stub(:body).and_return({"errors" => "Not authenticated"}.to_json)
      allow(response).to receive(:body).and_return({"errors" => "Not authenticated"}.to_json)
      #authentication.stub(:response).and_return(response)
      allow(authentication).to receive(:response).and_return(response)
      
    end
    
    it "render a JSON error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end
    
    it "returns 401 status" do
      expect(response).to have_http_status(401)
    end
  end
  
  describe "#user_signed_in?" do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        # authentication.stub(:current_user).and_return(@user)
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it "returns true" do
        expect(authentication.user_signed_in?).to be true
      end
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        # authentication.stub(:current_user).and_return(nil)
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it "returns false" do
        expect(authentication.user_signed_in?).to be false
      end
    end
  end
  
end