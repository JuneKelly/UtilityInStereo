namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_clients_and_contacts
    make_projects
    make_events
    # make_phases
    # make_tasks
  end
end

def make_users
  @shane = User.create!(name: "Shane Kilkelly", 
                  email: "shanekilkelly@gmail.com",
                  password: "foobar", password_confirmation: "foobar")
  @ermin = User.create!(name: "Ermin Hamidovic",
                  email: 'ermin@systematicproductions.com',
                  password: 'betatestofdoom',
                  password_confirmation: 'betatestofdoom')
  @jarkko = User.create!(name: "Jarkko Mattheiszen",
                  email: 'jarkko@tainted-studio.com',
                  password: 'betatestofdoom',
                  password_confirmation: 'betatestofdoom')
  @jeff = User.create!(name: "Jeff Dunne",
                  email: 'jeff@arcanarecordings.com',
                  password: 'betatestofdoom',
                  password_confirmation: 'betatestofdoom')
  @dan = User.create!(name: "Dan Ballas",
                  email: 'dan@sonoritystudios.com',
                  password: 'betatestofdoom',
                  password_confirmation: 'betatestofdoom')
  @steven = User.create!(name: "Steven Otto",
                  email: 'stevenotto_3@hotmail.com',
                  password: 'betatestofdoom',
                  password_confirmation: 'betatestofdoom')
end

def make_clients_and_contacts
  # user = @shane
  # @client_one = user.clients.build(name: "First Client",
  #               description: "They are cool",
  #               website: "www.firstclient.com")
  # @client_two = user.clients.build(name: "Second Client",
  #               description: "Also cool",
  #               website: "www.secondclient.com")
  # @client_one.save
  # @client_two.save

  # contact_one = @client_one.contacts.build(name: "Joe Schmo",
  #                 role: "Guitarist-Songwriter",
  #                 email: "joeschmo@gmail.com",
  #                 phone: "01224456784")
  # contact_one.save

  # contact_two = @client_one.contacts.build(name: "Crazy Dave",
  #                 role: "Drummer",
  #                 email: "crazydave@gmail.com",
  #                 phone: "01224769845")
  # contact_two.save

  # Sample Client And contacts
  fgname = "Furious George And The Vipers Of Doom"
  fgdescription = "Rock band from London, Motorhead vibes, watch out for the drummer."
  fgwebsite = "www.thevipersofdoom.com"

  gname = "Furious George"
  grole = "Bassist / Vocalist"
  gemail = "furiousgeorge@crapmail.com"
  gphone = "0125467583423"

  User.all.each do |user| 
    client = user.clients.build(name: fgname, description: fgdescription,
                          website: fgwebsite)
    client.save
    contact_one = client.contacts.build(name: gname, role: grole,
                          email: gemail, phone: gphone)
    contact_one.save

    contact_two = client.contacts.build(name: "Crazy Dave",
                    role: "Drummer",
                    email: "crazydave@gmail.com",
                    phone: "01224769845")
    contact_two.save
  end
end

def make_projects
  User.all.each do |user|
    
    client = user.clients.first

    first_project = client.projects.build(title: "Black Lion EP",
                        details: "blah blah etc",
                        quotation: 5600.00,
                        deposit: 2000.00,
                        deposit_paid: true,
                        hourly_rate: 16.00,
                        deadline: 8.months.from_now)
    first_project.save

    first_phase = first_project.phases.build(title: "Pre Production",
                      details: "meetings and so forth",
                      is_flat_rate: true,
                      flat_rate: 150.00,
                      due_date: 4.days.ago,
                      is_done: true)
    second_phase = first_project.phases.build(title: "Tracking",
                      details: "Recording, 4 piece rock band",
                      is_flat_rate: false,
                      due_date: 3.months.from_now,
                      is_done: false)
    third_phase = first_project.phases.build(title: "Mixing",
                      details: "All mixing, and some over-dubs",
                      is_flat_rate: true,
                      flat_rate: 2000.00,
                      due_date: 5.months.from_now,
                      is_done: false)
    first_phase.save
    second_phase.save
    third_phase.save


    task_one = first_phase.tasks.build(title: "Meet the band")
    task_two = second_phase.tasks.build(title: "record drums")
    task_three = second_phase.tasks.build(title: "record guitars")
    task_four = second_phase.tasks.build(title: "record bass and vocals.")

    task_one.save
    task_two.save
    task_three.save
    task_four.save


    second_project = client.projects.build(title: "The Red Album",
                  details: "blah blah etc",
                  quotation: 10000.00,
                  deposit: 3500.00,
                  deposit_paid: false,
                  hourly_rate: 20.00,
                  deadline: 18.months.from_now)
    second_project.save
  end
end

def make_events
  users = User.all

  users.each do |user|
    user.events.build(title: "My First Event",
                      details: "This is simply an example event :)",
                      start_at: 4.days.from_now.strftime("%Y-%m-%d %H:%M:%S"),
                      end_at: 6.days.from_now.strftime("%Y-%m-%d %H:%M:%S")
                      ).save

    task = user.clients.first.projects.first.phases[1].tasks.first

    event = user.events.build(title: "Drum Session",
                      details: "At Ocean View Studios",
                      start_at: 8.days.from_now.strftime("%Y-%m-%d %H:%M:%S"),
                      end_at: 9.days.from_now.strftime("%Y-%m-%d %H:%M:%S"),
                      task_id: task.id)
    event.save
  end
end