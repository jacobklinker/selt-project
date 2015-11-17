require 'rails_helper'

describe LeaguesController do

    it "should load all leagues for the index" do
        expect(League).to receive(:all)
        post :index
    end

end