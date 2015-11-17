require 'rails_helper'

describe LeaguesController, type: :controller do
  
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }
  
  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }
  
  let(:valid_session) { {} }
  
  describe "GET #index" do
    it "assigns all leagues as @leagues" do
      league = League.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:leagues)).to eq([league])
    end
  end

  describe "GET #show" do
    it "assigns the requested league as @league" do
      league = League.create! valid_attributes
      get :show, {:id => league.to_param}, valid_session
      expect(assigns(:league)).to eq(league)
    end
  end

  describe "GET #new" do
    it "assigns a new league as @league" do
      get :new, {}, valid_session
      expect(assigns(:league)).to be_a_new(League)
    end
  end

  describe "GET #edit" do
    it "assigns the requested league as @league" do
      league = League.create! valid_attributes
      get :edit, {:id => league.to_param}, valid_session
      expect(assigns(:league)).to eq(league)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new League" do
        expect {
          post :create, {:league => valid_attributes}, valid_session
        }.to change(League, :count).by(1)
      end

      it "assigns a newly created league as @league" do
        post :create, {:league => valid_attributes}, valid_session
        expect(assigns(:league)).to be_a(League)
        expect(assigns(:league)).to be_persisted
      end

      it "redirects to the created league" do
        post :create, {:league => valid_attributes}, valid_session
        expect(response).to redirect_to(League.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved league as @league" do
        post :create, {:league => invalid_attributes}, valid_session
        expect(assigns(:league)).to be_a_new(League)
      end

      it "re-renders the 'new' template" do
        post :create, {:league => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => new_attributes}, valid_session
        league.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested league as @league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => valid_attributes}, valid_session
        expect(assigns(:league)).to eq(league)
      end

      it "redirects to the league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => valid_attributes}, valid_session
        expect(response).to redirect_to(league)
      end
    end

    context "with invalid params" do
      it "assigns the league as @league" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => invalid_attributes}, valid_session
        expect(assigns(:league)).to eq(league)
      end

      it "re-renders the 'edit' template" do
        league = League.create! valid_attributes
        put :update, {:id => league.to_param, :league => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested league" do
      league = League.create! valid_attributes
      expect {
        delete :destroy, {:id => league.to_param}, valid_session
      }.to change(League, :count).by(-1)
    end

    it "redirects to the leagues list" do
      league = League.create! valid_attributes
      delete :destroy, {:id => league.to_param}, valid_session
      expect(response).to redirect_to(leagues_url)
    end
  end

end