# Exemplo de blocos de comandos
# e procs

# criação da Proc
# uso: Proc.new bloco
#      proc bloco

b = proc {|s| puts s }

b.call("invocando proc")

def use_proc(string)
  if block_given?
    yield(string)
  else
    puts "Não foi passado um bloco de comandos"
  end
end

puts "sem passar a um bloco"
use_proc("sem bloco")

puts "primeiro exemplo"
use_proc("passando uma proc", &b)

puts "segundo exemplo"
use_proc(2) {|n| puts n*2 }

