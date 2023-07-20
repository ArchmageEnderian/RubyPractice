def foobar(num1, num2)
  if num1 == 20 || num2 == 20
    return num2
  else
    return num1 + num2
  end
end
puts foobar(1, 20)
puts foobar(20, 30)
puts foobar(2, 2)
