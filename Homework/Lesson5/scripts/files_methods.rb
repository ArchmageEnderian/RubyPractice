# frozen_string_literal: true

# Задание: Написать набор методов для работы с файлом

class FileMaster
  # Global variables

  def index
    @file_data
  end

  def find(id)
    @file_data[id - 1]
  end

  def where(pattern)
    @mass_of_findes = []
    @file_data.each do |line|
      @mass_of_findes.append(line) if line.include?(pattern)
    end
    @mass_of_findes
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

  def rewrite_file(file_path = @file_path, file_data = @file_data)
    if file_data.class == "String".class
      File.write(file_path, file_data)
    else
      File.write(file_path, file_data.join("\n"))
    end

  end

  def initialize(file_path)
    if File.exist?(file_path)
      open_file(file_path)
    else
      create_file(file_path, '')
      open_file(file_path)
    end
    @mass_of_findes = []
  end

  def open_file(file_path)
    file = File.open(file_path)
    @file_path = file_path
    @file_data = file.read.split("\n")
    file.close
  end

  def create_file(path, data = '')
    rewrite_file(path, data)
  end

  def empty?
    @file_data.empty?
  end
end

file_master1 = FileMaster.new('Homework/Lesson5/files/file_to_file.txt')

# puts file_master1.index
# file_master.find(1)
# file_master.where('58')
# file_master.update(2, "Phoenix Wright 26")
# file_master.delete(3)
# file_master.create("Phoenix Wright 33")



