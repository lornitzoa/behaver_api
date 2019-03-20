desc "This task is called by the Heroku scheduler add-on"
task :reset_daily_scores => :environment do
  puts "Resetting Daily Scores..."
  Score.resetDailyScores
  puts "done."
end

task :reset_task_completion => :environment do
  puts 'Resetting Task Completion'
  Task.resetCompletion
  puts 'done'
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
