require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create(:product)
      get :show, params: { id: @product.id }
    end
    
    it "returns the information about a reporter on a hash" do
      product_response = json_response[:product]
      expect(product_response[:title]).to eq @product.title
    end
    
    it "has the user as embeded object" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eq @product.user.email
    end
    
    it "returns 200 status" do
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      # get :index
    end
    
    context "when is not receiving any product_ids parameter" do
      before(:each) do
        get :index
      end
      it "returns 4 records from the database" do
        products_response = json_response[:products]
        expect(products_response.length).to be(4)
      end
      
      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end
      
      # Pagination
      it_behaves_like "paginated list"
      
      it "returns 200 status" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :product, user: @user }
        get :index, params: { product_ids: @user.product_ids }
      end
      it "returns just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eq @user.email
        end
      end
    end
  end
  
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attr = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attr }
      end
      
      it "renders the json representation for the product record just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq(@product_attr[:title])
      end
      
      it "returns 201 status" do
        expect(response).to have_http_status(201)
      end
    end
    
    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end
      
      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end
      
      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end
      
      it "returns 422 status" do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end
    
    context "when is successfully updated" do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @product.id, product: { title: "An expensive TV" } }
      end
      
      it "renders the JSON for updated user" do
        expect(json_response[:product][:title]).to eq "An expensive TV"
      end
      
      it "returns 200 status" do
        expect(response).to have_http_status(200)
      end
    end
    
    context "when is not updated" do
      before(:each) do
        patch :update, params: { user_id: @user.id, id: @product.id, product: { price: "Twelve dollars" } }
      end
      
      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end
      
      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end
      
      it "returns 422 status" do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: { user_id: @user.id, id: @product.id }
    end

    it "returns 204 status" do
      expect(response).to have_http_status(204)
    end
  end
end
