require 'spec_helper'

describe UsersController do
  describe'guest access' do
    it "GET#index redirects to the login form" do
      get :index
      response.should redirect_to login_url
    end

    it 'GET #new redirects to the login form' do
      get :new
      response.should redirect_to login_url
    end

    it 'POST #create redirects to the login form' do
      post :create, user: attributes_for(:user)
      response.should redirect_to login_url
    end
  end

  describe "user access" do
    before :each do
      session[:user_id] = create(:user).id
    end

    it "GET#index denies access" do
      get :index
      response.should redirect_to root_url
    end

    it "GET#new denies access" do
      get :new
      response.should redirect_to root_url
    end

    it "POST #create denies access" do
      post :create, user: attributes_for(:user)
      response.should redirect_to root_url
    end
  end

  describe "admin access" do
    before :each do
      @admin = create(:admin)
      session[:user_id] = @admin.id
    end

    describe "GET #index" do
      it "collects uers into @users" do
        user = create(:user)
        get :index
        assigns(:users).should == [@admin, user]
      end

      it "renders the :index template" do
        get :index
        response.should render_template :index
      end
    end

    describe "GET #new" do
      it "sets up a new, empty user" do
        get :new
        assigns(:user).should be_a_new(User)
      end

      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "adds the user" do
          expect{
            post :create, user: attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        it "redirects to users#index" do
          post :create, user: attributes_for(:user)
          response.should redirect_to users_url
        end
      end
    end









  end
end