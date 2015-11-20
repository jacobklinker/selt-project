class League < ActiveRecord::Base
  belongs_to :commissioner
  belongs_to :current_leader
  belongs_to :user1
  belongs_to :user2
  belongs_to :user3
  belongs_to :user4
  belongs_to :user5
  belongs_to :user6
  belongs_to :user7
  belongs_to :user8
  belongs_to :user9
  belongs_to :user10
  belongs_to :user11
  belongs_to :user12
  belongs_to :user13
  belongs_to :user14
  belongs_to :user15
  belongs_to :user16
  belongs_to :user17
  belongs_to :user18
  belongs_to :user19
  belongs_to :user20
  
  def member_has_picked(league)
    
    @league=league
    pickMade=LeaguePick.where(:league_id => @league.id, :week => Time.now.strftime('%U'))
    
    pickMade.exists?
  end
end
