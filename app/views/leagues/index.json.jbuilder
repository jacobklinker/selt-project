json.array!(@leagues) do |league|
  json.extract! league, :id, :league_name, :commissioner_id, :current_leader_id, :conference_settings, :number_picks_settings, :number_members, :user1_id, :user2_id, :user3_id, :user4_id, :user5_id, :user6_id, :user7_id, :user8_id, :user9_id, :user10_id, :user11_id, :user12_id, :user13_id, :user14_id, :user15_id, :user16_id, :user17_id, :user18_id, :user19_id, :user20_id
  json.url league_url(league, format: :json)
end
