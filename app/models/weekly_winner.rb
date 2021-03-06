class WeeklyWinner < ActiveRecord::Base
    serialize :winners,Array
    
    def self.determine_weekly_winners
        
        test_league=League.all.take
        year = Time.now.strftime('%Y').to_i
        
        if(test_league.bowlSeason==true)
            week=49...53, 0...2
            year=year-1
        else
            week = ((Time.now.strftime('%U').to_i)-1)
        end
        
        #Need to delete
        #week=week+1
        #
        
        League.all.each do |league|
            
            @league_picks = LeaguePick.where(league_id: league.id, week: week).find_each
            if(@league_picks.any?) then 
                current_leader=@league_picks.next_values[0]
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
                        if(league_pick.pushes>current_leader.pushes)
                            if(User.find(current_leader.user_id)!=league_pick.user_id)
                                current_leader=league_pick
                                winners=[]
                                winners.push(current_leader.user_id)
                            end
                        elsif(league_pick.pushes==current_leader.pushes)
                            challengingTiebreaker=TiebreakerPick.where(league_pick_id: league_pick.id).take
                            #puts challengingTiebreaker
                            currentTiebreaker=TiebreakerPick.where(league_pick_id: LeaguePick.where(user_id: winners[0], week: week, league_id: league.id)).take
                            #puts currentTiebreaker
                            totalScore= Game.find(challengingTiebreaker.game_id).home_score + Game.find(challengingTiebreaker.game_id).away_score
                            #puts "total score"
                            #puts totalScore
                            #puts currentTiebreaker.points_estimate
                            #puts challengingTiebreaker.points_estimate
                            if((currentTiebreaker.points_estimate-totalScore).abs < (challengingTiebreaker.points_estimate-totalScore).abs )
                            elsif((currentTiebreaker.points_estimate-totalScore).abs > (challengingTiebreaker.points_estimate-totalScore).abs)
                                current_leader=league_pick
                                winners=[]
                                winners.push(current_leader.user_id)
                            else
                                winners.push(league_pick.user_id)
                            end
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