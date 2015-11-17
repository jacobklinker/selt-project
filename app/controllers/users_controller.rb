class UsersController < ApplicationController
    before_filter :set_current_user
  
    def set_current_user
      @user = current_user;
    end
    
    def index
        if @user == nil then 
            redirect_to unauthenticated_root_path
            return
        end
        
        ids = [];
        ids << @user.league1_id unless @user.league1_id == nil
        ids << @user.league2_id unless @user.league2_id == nil
        ids << @user.league3_id unless @user.league3_id == nil
        ids << @user.league4_id unless @user.league4_id == nil
        ids << @user.league5_id unless @user.league5_id == nil
        
        @leagues = [];
        ids.each do |league_id|
            league = League.find(league_id);
            user = User.find(league.commissioner_id);
            @leagues << {
                :league => league,
                :commissioner => user.first_name + " " + user.last_name,
                :position => "1/12"
            };
        end
    end
    
    def sign_in
    end
    
end