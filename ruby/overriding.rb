puts "Iremos sobrescrever o metodo puts"

def puts(string, value)
  value.times{super(string)}
end

puts "essa mensagem sera impressa 3 vezes",3

###
# Se tentarmos chamar o metodo com o numero
# original de argumentos teremos um erro.

begin
  puts "forma original"
rescue ArgumentError => e
  puts "#{e.message}", 1
end

###
# Então podemos fazer com que o value
# ja esta definido

def puts(string, value = 1)
  value.times{super(string)}
end

begin
  puts "forma original"
rescue ArgumentError => e
  puts "#{e.message}", 1
end

