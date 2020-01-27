require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade 
    @id = id
  end

  def self.create_table
    sql =  <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade TEXT
      )
      SQL
  DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(hash_of_attributes)
    name = nil
    grade = nil
    hash_of_attributes.each do |key, value|
      if key == :name 
        name = value 
      else
        grade = value
      end
    end
    name = Student.new(name, grade)
    name.save 
    name
  end
  
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end
