class Tiebreaker < ActiveRecord::Base
    has_one :league
    has_one :game
end