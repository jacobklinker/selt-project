class WeeklyWinner < ActiveRecord::Base
    serialize :winners,Array
    
    def self.determine_weekly_winners
        week = ((Time.now.strftime('%U').to_i)-1)
        year = Time.now.strftime('%Y').to_i
        
        #Need to delete
        #week=week+1
        #

        League.all.each do |league|
            puts "In leagues"
            @league_picks = LeaguePick.where(league_id: league.id, week: week).find_each
            if(@league_picks.any?) then 
                current_leader=@league_picks.next_values[0]
                puts User.find(current_leader.user_id).first_name
                maxScore=current_leader.wins
                winners=[]
                winners.push(current_leader.user_id)
                @league_picks.each do |league_pick|
                    if(league_pick.wins>maxScore)
                        maxScore=league_pick.wins
                        if(User.find(current_leader.user_id)!=User.find(league_pick.user_id))
                            current_leader=league_pick
                            winners=[]
                            winners.push(current_leader.user_id)
                        end
                    elsif((league_pick.wins==maxScore) && (User.find(current_leader.user_id)!=User.find(league_pick.user_id)))
                        puts league_pick.user_id
                        puts league_pick.pushes
                        puts current_leader.user_id
                        puts current_leader.pushes
                        if(league_pick.pushes>current_leader.pushes)
                            if(User.find(current_leader.user_id)!=league_pick.user_id)
                                current_leader=league_pick
                                winners=[]
                                winners.push(current_leader.user_id)
                            end
                        elsif(league_pick.pushes==current_leader.pushes)
                            winners.push(league_pick.user_id)
                        end
                    end
                end
                week_winners=WeeklyWinner.new
                week_winners.league_id=league.id
                week_winners.week=week
                week_winners.year=year
                week_winners.winners=winners
    
                week_winners.save!
            end
        end
        
        def self.update_standings
        end
    end
end
