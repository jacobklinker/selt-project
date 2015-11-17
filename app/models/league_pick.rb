class LeaguePick < ActiveRecord::Base
    has_many :picks
    has_one :user
    has_one :league
end