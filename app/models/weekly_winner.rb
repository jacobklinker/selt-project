class WeeklyWinner < ActiveRecord::Base
    serialize :winners,Array
end
