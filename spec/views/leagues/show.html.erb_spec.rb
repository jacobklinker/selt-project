require 'rails_helper'

describe "leagues/show", type: :view do
  before(:each) do
    @league = assign(:league, League.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/League Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Conference Settings/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end