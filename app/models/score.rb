class Score

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  def self.resetDailyScores
    puts '============resetting scores========='
    getChildren = DB.exec('SELECT * FROM members WHERE role="child"')
    getChildren.map do |child|
      return {
        'id' => child['id'],
        'name' => child['name']
      }
  end

  # Index
  def self.all
    results = DB.exec('SELECT * FROM scores;')
    results.map do |result|
      {
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
    end
  end

  # Create
  def self.create(opts)
    results = DB.exec(
      <<-SQL
        INSERT INTO scores
          (date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash)
        VALUES
          ('#{opts['date']}', #{opts['member_id']}, #{opts['bx_points_earned']}, #{opts['req_tasks_complete']}, #{opts['req_tasks_assigned']}, #{opts['bonus_tasks_complete']}, #{opts['bonus_tasks_assigned']}, #{opts['task_points_earned']}, #{opts['total_points_earned']}, #{opts['points_used']}, #{opts['points_available']}, #{opts['stashed_cash']})
        RETURNING id, date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash
      SQL
    )
    result = results.first
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
        (#{opts['member_id']},
        #{opts['bx_points_earned']},
        #{opts['req_tasks_complete']},
        #{opts['req_tasks_assigned']},
        #{opts['bonus_tasks_complete']},
        #{opts['bonus_tasks_assigned']},
        #{opts['task_points_earned']},
        #{opts['total_points_earned']},
        #{opts['points_used']},
        #{opts['points_available']},
        #{opts['stashed_cash']})
        RETURNING
          id, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash
      SQL
    )
    result = results.first
    return {
      'id' => result[id].to_i,
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
  end



end
