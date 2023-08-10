# frozen_string_literal: true

require 'socket'
require_relative '../server/app'

app = App.new
server = TCPServer.open('0.0.0.0', 3000)


while connection = server.accept
  request = connection.gets

  method, full_path = request.split(' ')
  path, params = full_path.split('?')

  status, headers, body = app.call({
                                     'REQUEST-METHOD' => method,
                                     'PATH_INFO' => path,
                                     'QUERY_STRING' => params
                                   })

  connection.print "HTTP/1.1 #{status}\r\n" # Версия протокола, статус код
  headers.each do |key, value|
    connection.print "#{key}:#{value}\r\n" # Заголовок
  end

  connection.print "\r\n" # Пустая строка

  body.each do |part|
    connection.print part # Тело
  end

  connection.close
end
