def add_pokemon(pokemon_array, name, color)
  pokemon_array << { name: name, color: color }
end

def create_pokemon_array
  pokemon_array = []
  puts "Сколько покемонов нужно добавить?"
  num_pokemons = gets.chomp.to_i

  num_pokemons.times do |i|
    puts "Введите имя покемона #{i + 1}:"
    name = gets.chomp
    puts "Введите цвет покемона #{i + 1}:"
    color = gets.chomp
    add_pokemon(pokemon_array, name, color)
  end

  pokemon_array
end

pokemon_array = create_pokemon_array
puts pokemon_array