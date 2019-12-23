require 'rails_helper'
require 'support/request_helpers'

RSpec.describe Api::V1::UsersController, type: :controller do
  
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      get :show, params: { id: @user.id }
    end
    
    it "returns the information about a reporter on a hash" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eq @user.email
    end
    
    it "has the product ids as an embeded object" do
      user_response = json_response[:user]
      expect(user_response[:product_ids]).to eq []
    end
    
    it "returns 200 success status" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
      end
      
      it "renders the json representation for the user record just created" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq @user_attributes[:email]
      end
      
      it "returns 201 status" do
        expect(response).to have_http_status(201)
      end
    end
    
    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, params: { user: @invalid_user_attributes }
      end
      
      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it "returns 422 status" do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe "PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end
    context "when is successfully updated" do
      before(:each) do
        patch :update, params: { id: @user.id, user: { email: "abcd@efgh.com" } }
      end
      
      it "renders the json representation for the user record just updated" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq "abcd@efgh.com"
      end
      
      it "returns 200 success status" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "when is not updated" do
      before(:each) do
        patch :update, params: { id: @user.id, user: { email: "abcd" } }
      end
      
      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end
      
      it "renders the json errors on why the user could not be updated" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it "returns 422 status" do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "when deleted successfully" do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        delete :destroy, params: { id: @user.id }
      end
      
      it "returns 204 status" do
        expect(response).to have_http_status(204)
      end
    end
  end
  
end
