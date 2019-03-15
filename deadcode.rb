#### TESTING FOR SCHEDULES SCORE UPDATES
INSERT INTO scores
  (date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash)
VALUES
  ('3/15/2019', 13, 500, 20, 30, 5, 10, 150, 650, 600, 50, 300)
RETURNING id, date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash


return {
  'id' => result['id'].to_i,
  'date' => result['date'],
  'member_id' => result['member_id'].to_i,
  'bx_points_earned' => result['bx_points_earned'].to_i,
  'req_tasks_complete' => result['req_tasks_complete'].to_i,
  'req_tasks_assigned' => result['req_tasks_assigned'].to_i,
  'bonus_tasks_complete' => result['bonus_tasks_complete'].to_i,
  'bonus_tasks_assigned' => result['bonus_tasks_assigned'].to_i,
  'task_points_earned' => result['task_points_earned'].to_i,
  'total_points_earned' => result['total_points_earned'].to_i,
  'points_used' => result['points_used'].to_i,
  'points_available' => result['points_available'].to_i,
  'stashed_cash' => result['stashed_cash'].to_i
}







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
