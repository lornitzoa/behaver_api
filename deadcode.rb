#### TESTING FOR SCHEDULES SCORE UPDATES

INSERT INTO scores
  (date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash)
VALUES
  ('3/14/2019', 13, 0, 0, 10, 0, 5, 0, 0, 0, 50, 100)




puts '============resetting scores========='

puts dateNow = DateTime.now

resetScores = DB.exec(
  <<-SQL
  INSERT INTO scores
    (date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash)
  VALUES
    ('#{today}', #{child['member_id']}, 0, 0, 10, 0, 5, 0, 0, 0, 0, 100)
  RETURNING id, date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash
  SQL
)
puts '----------------mapping------------'


getTodaysScores = DB.exec(
  <<-SQL
    SELECT *
    FROM scores
    WHERE date='#{today}' AND member_id=#{child['member_id']}
  SQL
)






# assign task functional code before setting recurrance attempts

results = DB.exec(
  <<-SQL
    INSERT INTO assigned_tasks
      (child_id, task_id, frequency, time_of_day, points, required, completed)
    VALUES
      (#{opts["child_id"]}, #{opts["task_id"]}, '#{opts["frequency"]}', '#{opts["time_of_day"]}', #{opts["points"]}, #{opts["required"]}, #{opts["completed"]})
    RETURNING id, child_id, task_id, frequency, time_of_day, points, required, completed
  SQL
)
result = results.first
return {
  'id' => result['id'].to_i,
  'child_id' => result['child_id'].to_i,
  'task_id' => result['task_id'].to_i,
  'frequency' => result['frequency'],
  'time_of_day' => result['time_of_day'],
  'points' => result['points'].to_i,
  'required' => result['required'],
  'completed' => result['completed'],
}

# index task assignments
{
  'id' => result['id'].to_i,
  'child_id' => result['child_id'].to_i,
  'task_name' => result['task'],
  'frequency' => result['frequency'],
  'separation_count' => result['separation_count'].to_i,
  'week_day' => result['week_day'].to_i,
  'time_of_day' => result['time_of_day'],
  'points' => result['points'],
  'required' => result['required'],
  'completed' => result['completed'],
}


DateTime.now.to_date.wday >= 1 || DateTime.now.to_date.wday <= 5
