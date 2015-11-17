require 'rails_helper'

describe "leagues/index", type: :view do
  before(:each) do
    assign(:leagues, [
      League.create!(
        :league_name => "League Name",
        :commissioner => nil,
        :current_leader => nil,
        :conference_settings => "Conference Settings",
        :number_picks_settings => 1,
        :number_members => 2,
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
      ),
      League.create!(
        :league_name => "League Name",
        :commissioner => nil,
        :current_leader => nil,
        :conference_settings => "Conference Settings",
        :number_picks_settings => 1,
        :number_members => 2,
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
      )
    ])
  end

  it "renders a list of leagues" do
    render
    assert_select "tr>td", :text => "League Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Conference Settings".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end