# frozen_string_literal: true

require 'rack'
require_relative '../scripts/cash_machine'

class App

  def initialize
    @cash_machine = CashMachine.new('Homework/Lesson7/files/balance.txt')
    @html_params_hash = { 'Content-Type' => 'text/html; charset=utf-8' }
  end

  def call(env)
    req = Rack::Request.new(env)
    params = req.query_string.split('&').map { |pair| pair.split('=') }.to_h

    router(req.path, params)
  end

  def router(path, params)
    case path
    when '/'
      [200, @html_params_hash, [@cash_machine.init_status, @cash_machine.help]]
    when '/deposit'
      [404, @html_params_hash, [@cash_machine.deposit(params['value'].to_i)]]
    when '/withdraw'
      [404, @html_params_hash, [@cash_machine.withdraw(params['value'].to_i)]]
    when '/show-balance'
      [200, @html_params_hash, [@cash_machine.show_balance]]
    else
      [404, @html_params_hash, ['Ошибка 404! Страница не найдена!']]
    end
  end
end