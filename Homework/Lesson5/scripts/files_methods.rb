# frozen_string_literal: true

class FileMaster
  # Global variables

  def index
    puts @file_data
  end

  def find(id)
    puts @file_data[id - 1]
  end

  def where(pattern)
    @file_data.each do |line|
      puts line if line.include?(pattern)
    end
  end

  def update(id, text)
    @file_data[id - 1] = text
    rewrite_file
  end

  def delete(id)
    @file_data.delete_at(id - 1)
  end

  def create(name)
    @file_data.append(name)
    rewrite_file
  end

  def rewrite_file
    File.write(@file_name, @file_data.join("\n"))
  end

  def initialize(file_name)
    file = File.open(file_name)
    @file_name = file_name
    @file_data = file.read.split("\n")
    file.close
  end

end

file_master = FileMaster.new('Homework/Lesson4/files/file_to_read.txt')

file_master.index
file_master.find(1)
file_master.where('Ivan')
file_master.update(2, "Phoenix Wright 26")
file_master.delete(3)
file_master.create("Phoenix Wright 33")



