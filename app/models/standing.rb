class Standing < ActiveRecord::Base
    serialize :weeklyScore,Array
    belongs_to :league
    has_one :user
end
