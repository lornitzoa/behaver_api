class Member

  # Connections
  if(ENV['DATABASE_URL'])
      uri = URI.parse(ENV['DATABASE_URL'])
      DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
      DB = PG.connect(:host => 'localhost', :port => 5432, :dbname => 'behaver_api_development')
    end

    # Index
    def self.all
      results = DB.exec('SELECT * FROM members')
      results.map do |result|
      return {
          'member_id' => result['member_id'].to_i,
          'name' => result['name'],
          'role' => result['role'],
          'pin' => result['pin'].to_i,
          'family_id' => result['family_id'].to_i
        }
      end
    end

    # Show
    def self.find(id)
      results = DB.exec(
        <<-SQL
          SELECT *
          FROM members
          WHERE id=#{id}
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
            ('#{opts["name"]}', '#{opts["role"]}', #{opts["pin"]}, '#{opts["family_id"]}')
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
