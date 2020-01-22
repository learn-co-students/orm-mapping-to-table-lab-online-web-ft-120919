class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
  end #init

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end #self.create_table

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students 
    SQL
    DB[:conn].execute(sql)
  end #self.drop_table

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end #save

  #Why is this a class method? Same reason initialize is a class method?
  def self.create(attr_hash)
    student = Student.new(attr_hash[:name], attr_hash[:grade])
    student.save
    student 
  end #self.create
  
end #class
