class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
    DB[:conn].execute(sql, name, grade)
    sql_get = "SELECT id FROM students WHERE (name, grade) = (?, ?);"
    @id = DB[:conn].execute(sql_get, name, grade)[0][0]
    self
  end

  def self.create(attr_hash)
    student = new(attr_hash[:name], attr_hash[:grade])
    student.save
  end
end
