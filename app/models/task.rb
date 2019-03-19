require 'date'
class Task

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

    # Index
    def self.all
      results = DB.exec(
        <<-SQL
          SELECT * FROM tasks
        SQL
      )
      results.map do |result|
        {
          'id' => result['id'].to_i,
          'task' => result['task'],
          'family_id' => result['family_id']
        }
      end
    end

    # Index Assigned Tasks
    def self.indexAssignments
      results = DB.exec(
        <<-SQL
          SELECT assigned_tasks.*, tasks.task
          FROM assigned_tasks
          INNER JOIN tasks
            ON assigned_tasks.task_id = tasks.id

        SQL
      )
      results.map do |result|
        if result["frequency"] === "weekdays" && (DateTime.now.to_date.wday >= 1 || DateTime.now.to_date.wday <= 5)
          {
            'id' => result['id'].to_i,
            'child_id' => result['child_id'].to_i,
            'task_name' => result['task'],
            'frequency' => result['frequency'],
            'time_of_day' => result['time_of_day'],
            'points' => result['points'],
            'required' => result['required'],
            'completed' => result['completed'],
          }
        elsif result["frequency"] === "weekends" && (DateTime.now.to_date.wday === 0 || DateTime.now.to_date.wday === 6)
          {
            'id' => result['id'].to_i,
            'child_id' => result['child_id'].to_i,
            'task_name' => result['task'],
            'frequency' => result['frequency'],
            'time_of_day' => result['time_of_day'],
            'points' => result['points'],
            'required' => result['required'],
            'completed' => result['completed'],
          }
        elsif result["frequency"] === "daily"
          {
            'id' => result['id'].to_i,
            'child_id' => result['child_id'].to_i,
            'task_name' => result['task'],
            'frequency' => result['frequency'],
            'time_of_day' => result['time_of_day'],
            'points' => result['points'],
            'required' => result['required'],
            'completed' => result['completed'],
          }
        end
      end
    end

    # Create
    def self.create(opts,opts2)
      results = DB.exec(
        <<-SQL
          INSERT INTO tasks
            (task, family_id)
          VALUES
            ('#{opts}', #{opts2})
          RETURNING id, task, family_id
        SQL
      )
      result = results.first
      return {
          'id' => result['id'].to_i,
          'task' => result['task'],
          'family_id' => result['family_id']
        }
    end

    # Assign a Task
    def self.assignTask(opts)
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
    end

    #Update Assigned Task
    def self.updateAssignedTask(id, opts)
      puts opts
      results = DB.exec(
        <<-SQL
          UPDATE assigned_tasks
          SET
            child_id=#{opts["child_id"]}, task_id=#{opts["task_id"]}, frequency='#{opts["frequency"]}', time_of_day='#{opts["time_of_day"]}', points=#{opts["points"]}, required=#{opts["required"]}, completed=#{opts["completed"]}
          WHERE id=#{id}
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
    end


    # Delete
    def self.delete(id)
      results = DB.exec(
        <<-SQL
          DELETE FROM tasks WHERE id=#{id}
        SQL
      )
      return { 'deleted' => true}
    end

    # Delete Assigned Task
    def self.deleteAssignedTask(id)
      results = DB.exec(
        <<-SQL
          DELETE FROM assigned_tasks WHERE id=#{id}
        SQL
      )
      return { 'deleted': true }
    end

    # UPDATE
    def self.update(id, opts, opts2)
      results = DB.exec(
        <<-SQL
          UPDATE tasks
          SET
            task='#{opts}', family_id=#{opts2}
          WHERE id=#{id}
          RETURNING id, task, family_id
        SQL
      )
      result = results.first
      return {
        'id' => result['id'],
        'task' => result['task'],
        'family_id' => result['family_id']
      }
    end



end
