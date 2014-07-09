Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end

When /^I authorize with Trello with username "(.*?)" and password "(.*?)"$/ do |username, password|
  # focus on Trello window
  trello_popup = page.driver.window_handles.last
  page.within_window trello_popup do
    fake_chrome_drivers
    if page.has_content? "Switch Accounts"
      click_link "Switch Accounts"
    else
      click_link "Log in"
    end
    
    fill_in "email-login", with: username
    fill_in "password-login", with: password
    click_button "Log In"
    click_button "Allow"
  end
end

def fake_chrome_drivers
  page.driver.header(
    "User-Agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/34.0.1847.116 Chrome/34.0.1847.116 Safari/537.36"
    )
end

Given(/^the test user has connected to Trello$/) do
  page.set_rack_session token: "44988fd666c5c51542bc400e5d6515c2bc896eb3e370dc1622fe3c0f484e413a"
end

Given(/^the test user is in the system$/) do
  user = User.new
  user.email = "ollertapp@gmail.com"
  user.member_token = "44988fd666c5c51542bc400e5d6515c2bc896eb3e370dc1622fe3c0f484e413a"
  user.password = "testing ollert"
  user.trello_name = "ollerttest"

  user.save!
end

Given(/^the doppelganger user is in the system$/) do
  user = User.new
  user.email = "doppelganger@gmail.com"
  user.password = "password"

  user.save!
end

Given(/^the test user is logged in$/) do
  page.set_rack_session user: User.find_by(email: "ollertapp@gmail.com").id
end

Then(/^there should be (\d+) user(?:s?) in the system$/) do |num_users|
  User.count.should eq num_users.to_i
end

When(/^the val of "(.*?)" is "(.*?)"$/) do |selector, value|
  expect(page.find(selector)[:value]).to eq value
end
