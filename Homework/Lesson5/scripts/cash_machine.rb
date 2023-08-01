# frozen_string_literal: true

require_relative 'files_methods'

class CashMachine

  CONST_BALANCE = 100
  def initialize(path)
    @file = FileMaster.new(path)
    if @file.empty?
      @file.create_file(path, CONST_BALANCE.to_s)
      @file = FileMaster.new(path)
    end

    @file.index.each do |line|
      @balance = line.to_i
    end
    puts 'Инициализация завершена! Добро пожаловать, Пользователь!'
  end

  def viewer
    puts 'Введите команду: '
    gets.chomp.downcase
  end

  def help(choice)
    puts "Команды #{choice} не существует! Возможные команды:
          W - Снять средства
          D - Внести депозит
          B - Проверить баланс
          Q - Ыыйти из терминала"
    gets.chomp.downcase
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
        puts "Ваш текущий баланс -> #{@balance}"
        choice = viewer
      when 'q'
        break
      else
        choice = help(choice)
      end
    end
    puts 'Конец.'
  end

  def withdraw
    puts 'Введите сумму, которую хотите обналичить: '
    money = gets.chomp.to_i

    if money.positive? && money <= @balance
      @balance -= money
    else
      until money.positive? && money <= @balance
        puts "Введите корректную сумму! Доступный номинал от 1 до #{@balance}"
        money = gets.chomp.to_i
      end
    end
    system('clear')
    puts 'Операция успешно завершена!'
  end

  def deposit
    puts 'Введите депозит. Доступный номинал: 50, 100, 200, 500, 1000, 2000, 5000'
    money = gets.chomp.to_i

    if [50, 100, 200, 500, 1000, 2000, 5000].include?(money)
      @balance += money
    else
      until [50, 100, 200, 500, 1000, 2000, 5000].include?(money)
        puts 'Введите корректную сумму! Доступный номинал: 100, 200, 500, 1000, 2000, 5000'
        money = gets.chomp.to_i
      end
    end
    system('clear')
    puts 'Операция успешно завершена!'
  end
end

a = CashMachine.new('Homework/Lesson5/files/balance.txt')
a.init
