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
