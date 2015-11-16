class UsersController < ApplicationController
    before_filter :set_current_user
  
    def set_current_user
      @user = current_user;
    end
    
    def index
        @leagues = [];
        
        if @user.league1_id != nil then
            l = League.find(@user.league1_id);
            u = User.find(l.commissioner_id);
            league = {
                :league => l,
                :commissioner => u.first_name + " " + u.last_name,
                :position => "1/12"
            };
            @leagues << league;
        end
        
        if @user.league2_id != nil then
            l = League.find(@user.league2_id);
            u = User.find(l.commissioner_id);
            league = {
                :league => l,
                :commissioner => u.first_name + " " + u.last_name,
                :position => "1/12"
            };
            @leagues << league;
        end
        
        if @user.league3_id != nil then
            l = League.find(@user.league3_id)
            u = User.find(l.commissioner_id);
            league = {
                :league => l,
                :commissioner => u.first_name + " " + u.last_name,
                :position => "1/12"
            };
            @leagues << league;
        end
        
        if @user.league4_id != nil then
            l = League.find(@user.league4_id)
            u = User.find(l.commissioner_id);
            league = {
                :league => l,
                :commissioner => u.first_name + " " + u.last_name,
                :position => "1/12"
            };
            @leagues << league;
        end
        
        if @user.league5_id != nil then
            l = League.find(@user.league5_id);
            u = User.find(l.commissioner_id);
            league = {
                :league => l,
                :commissioner => u.first_name + " " + u.last_name,
                :position => "1/12"
            };
            @leagues << league;
        end
    end
    
    def sign_in
    end
    
end