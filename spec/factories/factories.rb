require 'securerandom'

FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password  "foobar"
    password_confirmation "foobar"
    long_id     { SecureRandom.hex(16) }
    last_login    Time.now.utc
    is_active     true
    account_type  "standard"
    trial_expire { 14.days.from_now }
  end

  factory :client do
    sequence(:name) { |n| "Client #{n}" }
    sequence(:description) { |n| "blah #{n}" }
    sequence(:website) { |n| "www.client#{n}.com" }
    user
  end

  factory :contact do
    sequence(:name)   { |n| "Name #{n}" }
    sequence(:role)   { |n| "Role #{n}" }
    sequence(:email)  { |n| "email#{n}@gmail.com" }
    sequence(:phone)  { |n| "01234#{n}" }
    client
  end

  factory :project do
    sequence(:title)      { |n| "Project Title #{n}" }
    sequence(:details)    { |n| "Details #{n}" }
    quotation             5000.00
    hourly_rate           22.00
    deposit               1500.00
    deposit_paid          true
    is_paid_in_full       false
    deadline              { 6.months.from_now }
    has_client_view       false
    client_view_message   nil
    client
  end

  factory :phase do
    sequence(:title)      { |n| "Phase Title #{n}"}
    sequence(:details)    { |n| "Phase Details #{n}"}
    is_flat_rate          false
    due_date              1.month.from_now
    is_done               false
    project
  end

  factory :task do
    sequence(:title)      { |n| "Task #{n}" }
    is_done               false
    phase
  end

  factory :event do
    sequence(:title)      { |n| "Event #{n}" }
    start_at              2.days.from_now.to_time.strftime("%Y-%m-%d %H:%M:%S")
    end_at                4.days.from_now.to_time.strftime("%Y-%m-%d %H:%M:%S")
    user
    task
  end

  factory :enquiry do
    sequence(:name)       { |n| "Name #{n}" }
    sequence(:email)      { |n| "dude#{n}@crapmail.com" }
    message               { Faker::Lorem.paragraph(sentence_count = 3) }
    viewed                false
    user
  end
end