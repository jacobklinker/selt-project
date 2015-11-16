class UsersController < ApplicationController
    before_filter :set_current_user
  
    def set_current_user
      @user = current_user;
    end
    
    def index
        ids = [];
        ids << @user.league1_id unless @user.league1_id == nil
        ids << @user.league2_id unless @user.league2_id == nil
        ids << @user.league3_id unless @user.league3_id == nil
        ids << @user.league4_id unless @user.league4_id == nil
        ids << @user.league5_id unless @user.league5_id == nil
        
        @leagues = [];
        ids.each do |league_id|
            l = League.find(league_id);
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