require_relative 'files_methods'

class FIO_finder
  def initialize
    @file = FileMaster.new('Homework/Lesson5/files/file_to_read.txt')
    @fio_data = @file.index
    @find_data = []
  end

  def ask_user
    until (@fio_data - @find_data).empty?
      puts 'Введите возраст'
      age = gets.chomp.to_i
      while (age <= 0 || age > 150) && age != -1
        puts 'Введите корректный возраст!'
        age = gets.chomp.to_i
      end
      break unless age != -1

      @file.where(age.to_s).each do |line|
        @find_data.append(line)
      end
    end
    _exit
  end

  def _exit
    puts @find_data
    @file.rewrite_file('Homework/Lesson5/files/result.txt', @find_data)
  end
end

finder = FIO_finder.new
finder.ask_user
