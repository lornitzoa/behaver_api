class Reinforcement

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  # Index
  def self.all
    results = DB.exec('SELECT * FROM reinforcements;')
    results.map do |result|
      {
        'id' => result['id'].to_i,
        'reinforcement' => result['reinforcement'],
        'family_id' => result['family_id'].to_i
      }
    end
  end

  # Index Reinforcements Availabe To
  def self.indexReinforcements
    results = DB.exec(
      <<-SQL
        SELECT reinforcements_available_to.*, reinforcements.reinforcement
        FROM reinforcements_available_to
        INNER JOIN reinforcements
          ON reinforcements_available_to.reinforcement_id = reinforcements.id
      SQL
    )
    results.map do |result|
      {
        'id' => result['id'].to_i,
        'child_id' => result['child_id'].to_i,
        'reinforcement_id' => result['reinforcement_id'].to_i,
        'reinforcement' => result['reinforcement'],
        'points' => result['points'].to_i,
        'daily_allotment' => result['daily_allotment'],
        'no_available' => result['no_available'],
      }
    end
  end

  # Create a Reinforcement
  def self.create(opts, opts2)
    results = DB.exec(
      <<-SQL
        INSERT INTO reinforcements
          (reinforcement, family_id)
        VALUES
          ('#{opts}', #{opts2})
        RETURNING id, reinforcement, family_id
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'reinforcement' => result['reinforcement'],
      'family_id' => result['family_id'].to_i
    }
  end

  # Make Reinforcement Avaialble to Child
  def self.assignReinforcement(opts)
    results = DB.exec(
      <<-SQL
        INSERT INTO reinforcements_available_to
          (child_id, reinforcement_id, points, daily_allotment, no_available)
        VALUES
          (#{opts['child_id']}, #{opts['reinforcement_id']}, #{opts['points']}, '#{opts['daily_allotment']}', #{opts['no_available']})
        RETURNING id, child_id, reinforcement_id, points, daily_allotment, no_available
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'child_id' => result['child_id'].to_i,
      'reinforcement_id' => result['reinforcement_id'].to_i,
      'points' => result['points'].to_i,
      'daily_allotment' => result['daily_allotment'],
      'no_available' => result['no_available']
    }
  end

  # Delete a Reinforcement
  def self.delete(id)
    results = DB.exec(
      <<-SQL
        DELETE FROM reinforcements WHERE id=#{id}
      SQL
    )
    return { 'deleted': true}
  end

  # Delete Reinforcement Available to Child
  def self.deleteAssignedReinforcement(id)
    results = DB.exec(
      <<-SQL
        DELETE FROM reinforcements_available_to
        WHERE id=#{id}
      SQL
    )
    return { 'deleted': true}
  end

  # Update Reinforcement
  def self.update(id, opts, opts2)
    results = DB.exec(
      <<-SQL
        UPDATE reinforcements
        SET
          reinforcement='#{opts}', family_id=#{opts2}
        WHERE id=#{id}
        RETURNING id, reinforcement, family_id
      SQL
    )

  end

  # Update Reinforcement Available to Child
  def self.updateAssignedReinforcement(id, opts)
    results = DB.exec(
      <<-SQL
        UPDATE reinforcements_available_to
        SET
          child_id=#{opts['child_id']}, reinforcement_id=#{opts['reinforcement_id']}, points=#{opts['points']}, daily_allotment='#{opts['daily_allotment']}', no_available=#{opts['no_available']}
        WHERE id=#{id}
        RETURNING id, child_id, reinforcement_id, points, daily_allotment, no_available
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'child_id' => result['child_id'].to_i,
      'reinforcement_id' => result['reinforcement_id'].to_i,
      'points' => result['points'].to_i,
      'daily_allotment' => result['daily_allotment'],
      'no_available' => result['no_available']
    }
  end



end
