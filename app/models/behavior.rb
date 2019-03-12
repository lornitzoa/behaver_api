class Behavior

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  def self.all
    results = DB.exec('SELECT * FROM behaviors;')
    results.map do |result|
      {
        'id' => result['id'].to_i,
        'behavior' => result['behavior'],
        'targeted_for' => result['targeted_for']
      }
    end
  end

  def self.find(id)
    results = DB.exec(
      <<-SQL
        SELECT * FROM behaviors
        WHERE id=#{id}
      SQL
    )
    result = results.first
    return {
      'id' => result['id'],
      'behavior' => result['behavior'],
      'targeted_for' => result['targeted_for']
    }
  end

  def self.create(opts, opts2)
    results = DB.exec(
      <<-SQL
        INSERT INTO behaviors
          (behavior, targeted_for)
        VALUES
          ('#{opts}', '#{opts2}')
        RETURNING id, behavior, targeted_for
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'behavior' => result['behavior'],
      'targeted_for' => result['targeted_for']
    }
  end

  # Delete
  def self.delete(id)
    results = DB.exec(
      <<-SQL
        DELETE FROM behaviors WHERE id=#{id}
      SQL
    )
    return { 'deleted' => true}
  end

  def self.update(id, opts)
    puts opts
    results = DB.exec(
      <<-SQL
        UPDATE behaviors
        SET
          behavior='#{opts["behavior"]}', targeted_for='#{opts["targeted_for"]}'
        WHERE id=#{id}
        RETURNING id, behavior, targeted_for
      SQL
    )
    result = results.first
    return {
        'id' => result['id'].to_i,
        'behavior' => result['behavior'],
        'targeted_for' => result['targeted_for']
      }
  end














end
