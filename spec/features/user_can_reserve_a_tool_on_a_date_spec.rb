require "rails_helper"

RSpec.feature "User can reserve a tool on a date" do
  include SpecTestHelper

  scenario "- user views a tool and chooses a single date" do
    user1 = create(:user)
    tool1 = create(:tool)
    tool2 = create(:tool)
    login_user(user1)
    date = Date.parse("2017-05-02")
    year = "2017"
    month = "May"
    day = "2"
    visit tool_path(tool1.id)
    select year, from: "reserve_date_date_1i"
    select month, from: "reserve_date_date_2i"
    select day, from: "reserve_date_date_3i"
    click_on "Add to Cart"
    click_on "Item"
    click_on "Checkout"
    temp_date = DateReserved.last

    assert_equal 1, Reservation.count
    assert_equal tool1.id, Reservation.last.tool_id
    assert_equal 1, DateReserved.count
    assert_equal date, DateReserved.last.date_reserved
    assert_equal temp_date.id, Reservation.last.date_reserved_id
    assert_equal user1.id, Reservation.last.user_id

    click_on "Logout"

    visit tool_path(tool1.id)
    select year, from: "reserve_date_date_1i"
    select month, from: "reserve_date_date_2i"
    select day, from: "reserve_date_date_3i"
    click_on "Add to Cart"
    expect(page).to have_content "Tool Unavailable"

    visit tool_path(tool2.id)
    select year, from: "reserve_date_date_1i"
    select month, from: "reserve_date_date_2i"
    select day, from: "reserve_date_date_3i"
    click_on "Add to Cart"
    click_on "Item"
    expect(page).to have_content "Login or Create Account to Checkout"
  end
end
