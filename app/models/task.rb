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
      results = DB.exec('SELECT * FROM tasks;')
      results.map do |result|
        {
          'id' => result['id'].to_i,
          'task' => result['task']
        }
      end
    end

    # Create
    def self.create(opts)
      results = DB.exec(
        <<-SQL
          INSERT INTO tasks
            (task)
          VALUES
            ('#{opts}')
          RETURNING id, task
        SQL
      )
      result = results.first
      return {
          'id' => result['id'].to_i,
          'task' => result['task']
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

    # UPDATE
    def self.update(id, opts)
      results = DB.exec(
        <<-SQL
          UPDATE tasks
          SET
            task='#{opts}'
          WHERE id=#{id}
          RETURNING id, task
        SQL
      )
      result = results.first
      return {
        'id' => result['id'],
        'task' => result['task']
      }
    end

end
