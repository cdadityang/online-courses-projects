require 'rails_helper'

describe UsersController do
  describe "user access" do
    before :each do
      @user = create(:user)
      session[:user_id] = @user.id
    end
    
    describe "GET #index" do
      it "collects users into @users" do
        user = create(:user)
        get :index
        expect(assigns(:users)).to match_array [@user, user]
      end
      
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
      
      it "GET #new denies access" do
        get :new
        expect(response).to redirect_to root_path
      end
      
      it "POST #create denies access" do
        get :create
        expect(response).to redirect_to root_path
      end
    end
  end
end