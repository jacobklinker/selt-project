require 'rails_helper'

describe "game background sync" do
  
  describe "syncing with pinnacle sports api" do
    it "should not fail" do
      GamesSync.new.perform
    end
  end
  
end
