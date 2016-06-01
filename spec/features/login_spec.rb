require "rails_helper"

RSpec.feature "Users can log in to the site" do

  scenario "as a user with a valid account" do
    visit "/login"
    fill_in "Email", with: "user@ticketee.com"
    fill_in "Password", with: "password"
    click_button "Login222"
    
    expect(page).to have_content("You have been successfully logged in.")
  end
end

