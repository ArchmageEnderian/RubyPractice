module Resource
  def connection(routes)
    if routes.nil?
      puts "No route matches for #{self}"
      return
    end

    loop do
      print 'Choose verb to interact with resources (GET/POST/PUT/DELETE) / q to exit: '
      verb = gets.chomp
      break if verb == 'q'

      action = nil

      if verb == 'GET'
        print 'Choose action (index/show) / q to exit: '
        action = gets.chomp
        break if action == 'q'
      end


      action.nil? ? routes[verb].call : routes[verb][action].call
    end
  end
end

class PostsController
  extend Resource

  def initialize
    @posts = []
  end

  def index
    @posts.each_with_index do |post, index|
      puts "#{index + 1}: #{post}"
    end
  end

  def show_get_index
    # Если бы я смог уместить puts после знака равенства в аргементах функции show, то было бы классно, но увы
    puts 'Введите индекс: '
    (gets.chomp.to_i - 1)
  end

  def user_check(index)
    while @posts[index].nil?
      puts 'Ошибка! Такого поста не существет! Введите индекс повторно: '
      index = gets.chomp.to_i - 1
    end
    index
  end

  def show(index = show_get_index)
    index = user_check(index) if @posts[index].nil?
    puts("#{index + 1}: #{@posts[index]}")
  end

  def create
    puts 'Введите пост для добавления: '
    @posts.append(gets.chomp)
    show(@posts.length - 1)
  end

  def update
    puts 'Введите индекс: '
    index = user_check(gets.chomp.to_i - 1)
    puts 'Введите новый текст: '
    @posts[index] = gets.chomp
    show(index)
  end

  def destroy
    puts 'Введите индекс: '
    @posts.delete_at(user_check(gets.chomp.to_i - 1))
  end
end

class Router
  def initialize
    @routes = {}
  end

  def init
    resources(PostsController, 'posts')

    loop do
      print 'Choose resource you want to interact (1 - Posts, 2 - Comments, q - Exit): '
      choise = gets.chomp

      PostsController.connection(@routes['posts']) if choise == '1'
      break if choise == 'q'
    end

    puts 'Good bye!'
  end

  def resources(klass, keyword)
    controller = klass.new
    @routes[keyword] = {
      'GET' => {
        'index' => controller.method(:index),
        'show' => controller.method(:show)
      },
      'POST' => controller.method(:create),
      'PUT' => controller.method(:update),
      'DELETE' => controller.method(:destroy)
    }
  end
end

router = Router.new

router.init