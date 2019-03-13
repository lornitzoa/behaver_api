class Behavior

  # Connections
  if(ENV['DATABASE_URL'])
    uri = URI.parse(ENV['DATABASE_URL'])
    DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
  else
    DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
  end

  # Index
  def self.all
    results = DB.exec('SELECT * FROM behaviors;')
    results.map do |result|
      {
        'id' => result['id'].to_i,
        'behavior' => result['behavior'],
        'targeted_for' => result['targeted_for'],
        'family_id' => result['family_id']
      }
    end
  end

  # Index Assigned Behaviors
  def self.indexAssignments
  results = DB.exec(
    <<-SQL
      SELECT assigned_behaviors.*, behaviors.behavior, behaviors.targeted_for
      FROM assigned_behaviors
      INNER JOIN behaviors
        ON assigned_behaviors.behavior_id = behaviors.id
    SQL
  )
  results.map do |result|
    {
      'id' => result['id'].to_i,
      'child_id' => result['child_id'].to_i,
      'behavior' => result['behavior'],
      'points' => result['points'].to_i,
    }
  end
end

  # # Show
  # def self.find(id)
  #   results = DB.exec(
  #     <<-SQL
  #       SELECT * FROM behaviors
  #       WHERE id=#{id}
  #     SQL
  #   )
  #   result = results.first
  #   return {
  #     'id' => result['id'],
  #     'behavior' => result['behavior'],
  #     'targeted_for' => result['targeted_for'],
  #     'family_id' => result['family_id']
  #   }
  # end

  # Create a Behavior
  def self.create(opts, opts2, opts3)
    results = DB.exec(
      <<-SQL
        INSERT INTO behaviors
          (behavior, targeted_for, family_id)
        VALUES
          ('#{opts}', '#{opts2}', #{opts3})
        RETURNING id, behavior, targeted_for, family_id
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'behavior' => result['behavior'],
      'targeted_for' => result['targeted_for'],
      'family_id' => result['family_id'].to_i
    }
  end

  # Assign a Behavior
  def self.assignBehaviors(opts)
    results = DB.exec(
      <<-SQL
      INSERT INTO assigned_behaviors
        (child_id, behavior_id, points)
      VALUES (#{opts["child_id"]}, #{opts["behavior_id"]}, #{opts["points"]})
        RETURNING id, child_id, behavior_id, points
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'child_id' => result['child_id'].to_i,
      'behavior_id' => result['behavior_id'].to_i,
      'points' => result['points'].to_i,
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

  # Delete Assigned Behavior
  def self.deleteAssignedBehavior(id)
    results = DB.exec(
      <<-SQL
        DELETE FROM assigned_behaviors
        WHERE id=#{id}
      SQL
    )
    return {'deleted': true}
  end

  def self.update(id, opts, opts2, opts3)
    puts opts
    results = DB.exec(
      <<-SQL
        UPDATE behaviors
        SET
          behavior='#{opts}', targeted_for='#{opts2}', family_id=#{opts3}
        WHERE id=#{id}
        RETURNING id, behavior, targeted_for, family_id
      SQL
    )
    result = results.first
    return {
        'id' => result['id'].to_i,
        'behavior' => result['behavior'],
        'targeted_for' => result['targeted_for'],
        'family_id' => result['family_id']
      }
  end

  # Update Behavior Assignment
  def self.updateAssignedBehavior(id, opts)
    results = DB.exec(
      <<-SQL
        UPDATE assigned_behaviors
        SET
          child_id=#{opts['child_id']}, behavior_id=#{opts['behavior_id']}, points=#{opts['points']}
        WHERE id=#{id}
        RETURNING id, child_id, behavior_id, points
      SQL
    )
    result = results.first
    return {
      'id' => result['id'].to_i,
      'child_id' => result['child_id'].to_i,
      'behavior_id' => result['behavior_id'].to_i,
      'points' => result['points'].to_i,
    }
  end












end
