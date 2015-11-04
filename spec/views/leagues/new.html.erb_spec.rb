require 'rails_helper'

RSpec.describe "leagues/new", type: :view do
  before(:each) do
    assign(:league, League.new(
      :league_name => "MyString",
      :commissioner => nil,
      :current_leader => nil,
      :conference_settings => "MyString",
      :number_picks_settings => 1,
      :number_members => 1,
      :user1 => nil,
      :user2 => nil,
      :user3 => nil,
      :user4 => nil,
      :user5 => nil,
      :user6 => nil,
      :user7 => nil,
      :user8 => nil,
      :user9 => nil,
      :user10 => nil,
      :user11 => nil,
      :user12 => nil,
      :user13 => nil,
      :user14 => nil,
      :user15 => nil,
      :user16 => nil,
      :user17 => nil,
      :user18 => nil,
      :user19 => nil,
      :user20 => nil
    ))
  end

  it "renders new league form" do
    render

    assert_select "form[action=?][method=?]", leagues_path, "post" do

      assert_select "input#league_league_name[name=?]", "league[league_name]"

      assert_select "input#league_commissioner_id[name=?]", "league[commissioner_id]"

      assert_select "input#league_current_leader_id[name=?]", "league[current_leader_id]"

      assert_select "input#league_conference_settings[name=?]", "league[conference_settings]"

      assert_select "input#league_number_picks_settings[name=?]", "league[number_picks_settings]"

      assert_select "input#league_number_members[name=?]", "league[number_members]"

      assert_select "input#league_user1_id[name=?]", "league[user1_id]"

      assert_select "input#league_user2_id[name=?]", "league[user2_id]"

      assert_select "input#league_user3_id[name=?]", "league[user3_id]"

      assert_select "input#league_user4_id[name=?]", "league[user4_id]"

      assert_select "input#league_user5_id[name=?]", "league[user5_id]"

      assert_select "input#league_user6_id[name=?]", "league[user6_id]"

      assert_select "input#league_user7_id[name=?]", "league[user7_id]"

      assert_select "input#league_user8_id[name=?]", "league[user8_id]"

      assert_select "input#league_user9_id[name=?]", "league[user9_id]"

      assert_select "input#league_user10_id[name=?]", "league[user10_id]"

      assert_select "input#league_user11_id[name=?]", "league[user11_id]"

      assert_select "input#league_user12_id[name=?]", "league[user12_id]"

      assert_select "input#league_user13_id[name=?]", "league[user13_id]"

      assert_select "input#league_user14_id[name=?]", "league[user14_id]"

      assert_select "input#league_user15_id[name=?]", "league[user15_id]"

      assert_select "input#league_user16_id[name=?]", "league[user16_id]"

      assert_select "input#league_user17_id[name=?]", "league[user17_id]"

      assert_select "input#league_user18_id[name=?]", "league[user18_id]"

      assert_select "input#league_user19_id[name=?]", "league[user19_id]"

      assert_select "input#league_user20_id[name=?]", "league[user20_id]"
    end
  end
end
