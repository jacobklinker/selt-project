class LeaguePick < ActiveRecord::Base
    has_one :user
    has_one :league
end