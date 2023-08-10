# frozen_string_literal: true

require_relative 'files_methods'

class CashMachine

  CONST_BALANCE = 100
  def initialize(path)
    @status = false
    @file = FileMaster.new(path)
    if @file.empty?
      @file.create_file(path, CONST_BALANCE.to_s)
      @file = FileMaster.new(path)
    end

    @file.index.each do |line|
      @balance = line.to_i
    end
    @status = true
  end

  def init_status(exception = 'Unknown error!')
    if @status
      'Инициализация завершена! Добро пожаловать, Пользователь!'
    else
      "Ошибка загрузки! #{exception}"
    end
  end
  def viewer
    puts 'Введите команду: '
    gets.chomp.downcase
  end

  def help(choice = '')
    "\nВозможные запросы:\n
     /withdraw - Снять средства\n
     /deposit - Внести депозит\n
     /show-balance - Проверить баланс\n"
  end

  def init

    choice = viewer
    while choice != 'q'
      case choice
      when 'w'
        withdraw
        choice = viewer
      when 'd'
        deposit
        choice = viewer
      when 'b'
        puts show_balance
        choice = viewer
      when 'q'
        break
      else
        choice = help(choice)
      end
    end
    puts 'Конец.'
  end

  def withdraw(money = -1)

    if money.positive? && money <= @balance
      @balance -= money
      rewrite
      "Операция (withdraw) успешно завершена! #{show_balance}"
    else
      # until money.positive? && money <= @balance
      "Введите корректную сумму! Доступный номинал от 1 до #{@balance}"
        # money = gets.chomp.to_i
      # end
    end

    # puts 'Операция (withdraw) успешно завершена!'
  end

  def deposit(money = -1)
    # puts 'Введите депозит. Доступный номинал: 50, 100, 200, 500, 1000, 2000, 5000'
    # money = gets.chomp.to_i

    if [50, 100, 200, 500, 1000, 2000, 5000].include?(money)
      @balance += money
      rewrite
      "Операция (deposit) успешно завершена! #{show_balance}"
    else
      # until [50, 100, 200, 500, 1000, 2000, 5000].include?(money)
      'Введите корректную сумму! Доступный номинал: 100, 200, 500, 1000, 2000, 5000'
      # money = gets.chomp.to_i
      # end
    end

    # puts 'Операция (deposit) успешно завершена!'
  end

  def show_balance
    "Ваш текущий баланс -> #{@balance}"
  end

  def rewrite
    @file.rewrite_file(@file.file_path, @balance.to_s)
  end
end

# a = CashMachine.new('Homework/Lesson7/files/balance.txt')
# a.init
