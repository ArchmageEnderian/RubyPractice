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
    File.write(file_path, file_data.join("\n"))
  end

  def initialize(file_path)
    file = File.open(file_path)
    @file_path = file_path
    @file_data = file.read.split("\n")
    file.close

    @mass_of_findes = []
  end

end

file_master = FileMaster.new('Homework/Lesson5/files/file_to_read.txt')

# file_master.index
# file_master.find(1)
# file_master.where('58')
# file_master.update(2, "Phoenix Wright 26")
# file_master.delete(3)
# file_master.create("Phoenix Wright 33")



