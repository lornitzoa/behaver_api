require 'date'
require 'json'


class Member

  # Connections
  if(ENV['DATABASE_URL'])
      uri = URI.parse(ENV['DATABASE_URL'])
      DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
      DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
    end

    # Index
    def self.all(opts)
      puts "============ #{opts.to_i} ==============="
      results = DB.exec("SELECT * FROM members WHERE family_id=#{opts.to_i};")
      results.map do |result|
      {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'].to_i,
          'family_id' => result['family_id'].to_i
        }
      end
    end

    # Get Children
     def self.role
      results = DB.exec(
      <<-SQL
        SELECT name
        FROM members
        WHERE role='child'
      SQL
      )
      results.map do |result|
        {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'].to_i,
          'family_id' => result['family_id'].to_i
        }
      end
    end

    # Show Member
    def self.find(id)
      results = DB.exec(
        <<-SQL
          SELECT *
          FROM members
          WHERE member_id=#{id}
        SQL
      )
      result = results.first
      return {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'].to_i,
          'family_id' => result['family_id'].to_i
        }
    end

    # Create
    def self.create(opts)
      results = DB.exec(
        <<-SQL
          INSERT INTO members
            (name, role, pin, family_id)
          VALUES
            ('#{opts["name"]}', '#{opts["role"]}', '#{opts["pin"]}', '#{opts["family_id"]}')
          RETURNING member_id, name, role, pin, family_id
        SQL
      )
      result = results.first
      if(result['role'] === 'child')
        puts '============= is child ========='
        today = DateTime.now.to_date
        newChildScore = {
            "date" => "#{today}",
            "member_id" => result['member_id'],
            "bx_points_earned" => 0,
            "req_tasks_complete" => 0,
            "req_tasks_assigned" => 0,
            "bonus_tasks_complete" => 0,

            "bonus_tasks_assigned" => 0,
            "task_points_earned" => 0,
            "total_points_earned" => 0,
            "points_used" => 0,
            "points_available" => 0,
            "stashed_cash" => 0
          }
          # working on handling of adding new children to scores
          puts newChildScore
          Score.create(newChildScore)

      end
      return {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'],
          'family_id' => result['family_id']
        }
    end

    # Delete
    def self.delete(id)
      results = DB.exec(
        <<-SQL
          DELETE FROM members WHERE member_id=#{id}
        SQL
      )
      return { 'deleted' => true}
    end

    # Update

    def self.update(id, opts)
      results = DB.exec(
        <<-SQL
          UPDATE members
          SET
            name='#{opts["name"]}', role='#{opts["role"]}', pin='#{opts["pin"]}',family_id='#{opts["family_id"]}'
          WHERE member_id=#{id}
          RETURNING member_id, name, role, pin, family_id
        SQL
      )
      result = results.first
      return {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'],
          'family_id' => result['family_id']
        }
    end



end
