class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id:nil,name:, breed:)
    @id=id
    @name=name
    @breed=breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    if self.id
      self.update
    else
      sql =<<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      # binding.pry
      # @id == 1 in pry
    end
    self
  end

  def update
    DB[:conn].execute("UPDATE dogs SET name = ?, breed = ? WHERE = ?", self.name, self.breed, self.id)
  end

  def self.create(info)
    # binding.pry
    # [:name=>"Raplh",  :breed="lab"]
    dog=Dog.new(info)
    dog.save
    dog
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    binding.pry
    Dog.new(result[0], result[1], result[2])
  end

end
