def valid_login(user)
  visit login_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log In"
end

def invalid_login(user)
  visit login_path
  fill_in "Email",    with: "Invalid Name"
  fill_in "Password", with: "invalidpassword"
  click_button "Log In"
end

def logout
  click_link('Log Out')
end