def check_word(word)
  word.downcase.end_with?("cs")
end

def print_result(word)
  if check_word(word)
    2 ** word.length
  else
    word.reverse
  end
end

# Пример использования
puts print_result("I_like_CSS_CS")
puts print_result("I_love_Ruby_<3")