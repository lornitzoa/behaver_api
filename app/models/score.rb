require 'date'
require 'json'

class Score

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  def self.resetDailyScores
   getChildren = DB.exec(
     <<-SQL
       SELECT *
       FROM members
       WHERE role='child'
     SQL
   )
   getChildren.map do |child|
     # puts child['member_id']
     today = DateTime.now.to_date
     yesterday = DateTime.now.prev_day.to_date
     # tasks = []
     puts req_tasks = Task.indexAssignments.compact.select! { |task|
       task['child_id'] === child['member_id'].to_i && task['required'] === 't'
       # puts task['child_id'].class
       # puts child['member_id'].to_i
     }
     # puts req_tasks
     puts bonus_tasks = Task.indexAssignments.compact.select! { |task|
       task['child_id'] === child['member_id'].to_i && task['required'] === 'f'
     }
     # puts req_tasks.length
     # puts bonus_tasks.length
     # puts bonus_tasks
     # prevScores = DB.exec(
     #   <<-SQL
     #     SELECT *
     #     FROM scores
     #     WHERE date='#{yesterday}' AND member_id=#{child['member_id']}
     #   SQL
     # )
     # prevScores.map do |prevScore|
     #   puts 'mapping prevScores'
     #   puts prevScore['points_available']
     #   puts prevScore['stashed_cash']
     #   newStash = 200 #prevScore['points_available'].to_i + prevScore['stashed_cash'].to_i
     #
     #   resetScores = DB.exec(
     #     <<-SQL
     #     INSERT INTO scores
     #       (date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash)
     #     VALUES
     #       ('#{today}', #{child['member_id']}, 0, 0, #{req_tasks.length}, 0, #{bonus_tasks.length}, 0, 0, 0, 0, #{newStash})
     #     RETURNING id, date, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash
     #     SQL
     #   )
     # end

   end

 end


  # Index
  def self.all
    today = DateTime.now.to_date
    results = DB.exec(
      <<-SQL
        SELECT *
        FROM scores
        WHERE date='#{today}'
      SQL
    )
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

  # Patch
  def self.patch(member_id, opts)
    # puts opts.keys
    today = DateTime.now.to_date
    opts.keys.each { |opt|
      puts opt
      results = DB.exec(
        <<-SQL
          UPDATE scores
          SET #{opt}=#{opt} + #{opts[opt]}
          WHERE member_id=#{member_id} AND date='#{today}'
        SQL
      )
    }
    updateEarnedPoints = DB.exec(
      <<-SQL
        UPDATE scores
        SET total_points_earned=bx_points_earned + task_points_earned
          WHERE member_id=#{member_id} AND date='#{today}'
      SQL
    )
    updateAvailablePoints = DB.exec(
      <<-SQL
        UPDATE scores
        SET points_available=total_points_earned - points_used
        WHERE
          member_id=#{member_id} AND date='#{today}'
        RETURNING
          id, member_id, bx_points_earned, req_tasks_complete, req_tasks_assigned, bonus_tasks_complete, bonus_tasks_assigned, task_points_earned, total_points_earned, points_used, points_available, stashed_cash
      SQL
    )
    result = updateAvailablePoints.first
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
