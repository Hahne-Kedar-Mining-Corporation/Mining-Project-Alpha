require "rails_helper"

RSpec.feature "User can reserve a tool on a date" do
  include SpecTestHelper

  scenario "- user views a tool and chooses a single date" do
    # As a user,
    user1 = create(:user)
    tool1 = create(:tool)
    tool2 = create(:tool)
    login_user(user1)
    year = "2017"
    month = "May"
    day = "2"
    # when I view a tool,
    visit tool_path(tool1.id)
    # save_and_open_page
    select year, from: "reserve_date_date_1i"
    select month, from: "reserve_date_date_2i"
    select day, from: "reserve_date_date_3i"
    click_on "Add to Cart"
    click_on "Item"
    click_on "Checkout"

    assert_equal 1, Reservation.count
    assert_equal tool1.id, Reservation.last.tool_id
    assert_equal 1, Date.count
    assert_equal date, Date.last.dates_reserved
    assert_equal date.id, Reservation.last.date_id
    assert_equal user.id, Reservation.last.user_id

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
    # I can choose a single date,
    # and if the tool has already been reserved on that date I will see "tool unavailable,"
    # and if the tool has not been reserved I can add the tool to my cart.
  end
end
