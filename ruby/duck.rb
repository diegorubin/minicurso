class Music
  attr_accessor :title
end

class Book
  attr_accessor :title
end

def print_title(media)
  klass = case media.class.to_s
  when "Music"
    "Múscia"
  when "Book"
    "Livro"
  end 
  puts "#{klass}: #{media.title}"
end
m = Music.new; m.title = "Alive"
b = Book.new; b.title = "O Rei do Inverno"

print_title(m) # "Alive"
print_title(b) # "O Rei do Inverno"
