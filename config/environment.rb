# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MscApp::Application.initialize!

NewRelic::Agent.after_fork(:force_reconnect => true)