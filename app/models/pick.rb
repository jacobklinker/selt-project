class Pick < ActiveRecord::Base
    belongs_to :league_pick
    has_one :game
end