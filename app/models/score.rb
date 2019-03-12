class Score

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  # Index
  def self.all
    results = DB.exec('SELECT * FROM scores;')
    results.map do |result|
      {
        'member_id' => result['member_id'].to_i,
        'behavior_points' => result['behavior_points'].to_i,
        'tasks_completed' => result['tasks_completed'].to_i,
        'task_points' => result['task_points'].to_i,
        'stashed_cash' => result['stashed_cash'].to_i
      }
    end
  end

  # Create
  def self.create(opts)
    results = DB.exec(
      <<-SQL
        INSERT INTO scores
          (member_id, behavior_points, tasks_completed, task_points, stashed_cash)
        VALUES
          (#{opts['member_id']}, #{opts['behavior_points']},#{opts['tasks_completed']},#{opts['task_points']},#{opts['stashed_cash']})
        RETURNING member_id, behavior_points, tasks_completed, task_points, stashed_cash
      SQL
    )
    result = results.first
    return {
      'member_id' => result['member_id'].to_i,
      'behavior_points' => result['behavior_points'].to_i,
      'tasks_completed' => result['tasks_completed'].to_i,
      'task_points' => result['task_points'].to_i,
      'stashed_cash' => result['stashed_cash'].to_i
    }
  end

  # Delete
  def self.delete(member_id)
    results = DB.exec(`DELETE FROM scores WHERE member_id=#{member_id};`)
    return { 'deleted': true}
  end

  # Update
  def self.update(id, opts)
    results = DB.exec(
      <<-SQL
        UPDATE scores
        SET
          member_id=#{opts['member_id']}, behavior_points=#{opts['behavior_points']}, tasks_completed=#{opts['tasks_completed']}, task_points=#{opts['task_points']}, stashed_cash=#{opts['stashed_cash']}
        RETURNING
          member_id, behavior_points, tasks_completed, task_points, stashed_cash
      SQL
    )
    result = results.first
    return {
      'member_id' => result['member_id'].to_i,
      'behavior_points' => result['behavior_points'].to_i,
      'tasks_completed' => result['tasks_completed'].to_i,
      'task_points' => result['task_points'].to_i,
      'stashed_cash' => result['stashed_cash'].to_i
    }
  end



end
