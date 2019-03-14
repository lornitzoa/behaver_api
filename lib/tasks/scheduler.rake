desc "This task is called by the Heroku scheduler add-on"
task :rest_daily_scores => :environment do
  puts "Resetting Daily Scores..."
  Score.resetDailyScores
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
