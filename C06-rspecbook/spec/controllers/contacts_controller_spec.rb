require 'rails_helper'

describe ContactsController do
  
  let(:contact) { create(:contact) }
  
  shared_examples 'public access to contacts' do
    describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index, params: { letter: 'S' }
          expect(assigns(:contacts)).to match_array([smith])
        end
        it "renders the :index template" do
          get :index, params: { letter: 'S' }
          expect(response).to render_template :index
        end
      end
      
      context 'without params[:letter]' do
        it "populates an array of all contacts" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index
          expect(assigns(:contacts)).to match_array([smith, jones])
        end
        it "renders the :index template" do
          get :index
          expect(response).to render_template :index
        end
      end
    end
    
    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        # contact = create(:contact) # using let above
        get :show, params: { id: contact }
        expect(assigns(:contact)).to eq contact
      end
      it "renders the :show template" do
        # contact = create(:contact)
        get :show, params: { id: contact }
        expect(response).to render_template :show
      end
    end
  end
  
  shared_examples "full access to contacts" do
    describe 'GET #new' do
      it "assigns a new Contact to @contact" do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end
    
    describe 'GET #edit' do
      it "assigns the requested contact to @contact" do
        # contact = create(:contact)
        get :edit, params: { id: contact }
        expect(assigns(:contact)).to eq contact
      end
      it "renders the :edit template" do
        # contact = create(:contact)
        get :edit, params: { id: contact }
        expect(response).to render_template :edit
      end
    end
    
    describe "POST #create" do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end
      
      context "with valid attributes" do
        it "saves the new contact in the database" do
          expect{
            post :create, params: {contact: attributes_for(:contact, phones_attributes:@phones)}
          }.to change(Contact, :count).by(1)
        end
        
        it "redirects to contacts#show" do
          post:create, params: { contact: attributes_for(:contact, phones_attributes:@phones) }
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end
      
      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect{
            post :create, params: {contact: attributes_for(:invalid_contact)}
          }.to change(Contact, :count).by(0)
        end
        it "re-renders the :new template" do
          post :create, params: {contact: attributes_for(:invalid_contact)}
          expect(response).to render_template :new
        end
      end
    end
    
    describe 'PATCH #update' do
      before(:each) do
        @contact = create(:contact, firstname: "Larry", lastname: "Smith")
      end
      
      context "with valid attributes" do
        it "locates the request @contact" do
          patch :update, params: { id: @contact, contact: attributes_for(:contact) }
          expect(assigns(:contact)).to eq(@contact)
        end
        it "updates the contact in the database" do
          patch :update, params: { id: @contact, contact: attributes_for(:contact, firstname: "Larry", lastname: "Smith") }
          @contact.reload
          expect(@contact.firstname).to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end
        it "redirects to the contact" do
          patch :update, params: { id: @contact, contact: attributes_for(:contact) }
          expect(response).to redirect_to @contact
        end
      end
      
      context "with invalid attributes" do
        it "does not update the contact" do
          patch :update, params: { id: @contact, contact: attributes_for(:contact, firstname: "Larry", lastname: nil) }
          @contact.reload
          expect(@contact.firstname).to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end
        it "re-renders the :edit template" do
          patch :update, params: { id: @contact, contact: attributes_for(:invalid_contact) }
          expect(response).to render_template :edit
        end
      end
    end
    
    describe 'DELETE #destroy' do
      # before(:each) do
      #   @contact = create(:contact)
      # end
      it "deletes the contact from the database" do
        contact
        expect{
          delete :destroy, params: { id: contact }
        }.to change(Contact, :count).by(-1)
      end
      it "redirects to users #index" do
        contact
        delete :destroy, params: { id: contact }
        expect(response).to redirect_to contacts_path
      end
    end
  end
  
  describe "adminstrator access" do
    before :each do
      # user = create(:admin)
      # session[:user_id] = user.id
      set_user_session(create(:admin))
    end
    
    it_behaves_like "public access to contacts"
    
    it_behaves_like "full access to contacts"
    
    describe "PATCH hide_contact" do
      before(:each) do
        # @contact = create(:contact)
        patch :hide_contact, params: { id: contact }
      end
      
      it "marks the contact as hidden" do
        # expect(@contact.reload.hidden?).to be true
        # expect(@contact).to require_contact_hidden
        expect(contact).to require_contact_hidden
      end
      
      it "redirects to contacts#index" do
        expect(response).to redirect_to contacts_path
      end
    end
  end
  
  describe "user access" do
    before :each do
      # user = create(:user)
      # session[:user_id] = user.id
      set_user_session(create(:user))
    end
    
    it_behaves_like "public access to contacts"
    
    it_behaves_like "full access to contacts"
    
    describe "PATCH hide_contact" do
      before(:each) do
        # @contact = create(:contact)
        patch :hide_contact, params: { id: contact }
      end
      
      it "marks the contact as hidden" do
        # expect(@contact.reload.hidden?).to be true
        expect(contact).to require_contact_hidden
      end
      
      it "redirects to contacts#index" do
        expect(response).to redirect_to contacts_path
      end
    end
  end
  
  describe "guest access" do
    
    it_behaves_like "public access to contacts"
    
    describe "GET #new" do
      it "requires login" do
        get :new
        expect(response).to require_login
      end
    end
    
    describe "GET #edit" do
      it "requires login" do
        # contact = create(:contact)
        get :edit, params: { id: contact }
        expect(response).to require_login
      end
    end
    
    describe "POST #create" do
      it "requires login" do
        # contact = create(:contact)
        post :create, params: { id: contact, contact: attributes_for(:contact) }
        expect(response).to require_login
      end
    end
    
    describe "PATCH #update" do
      it "requires login" do
        put :update, params: { id: contact, contact: attributes_for(:contact) }
        expect(response).to require_login
      end
    end
    
    describe "DELETE #destroy" do
      it "requires login" do
        delete :destroy, params: { id: contact }
        expect(response).to require_login
      end
    end
  end
end