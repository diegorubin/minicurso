########
# Criando nossa exception

class MyException < Exception
end

puts "Exemplo do Rescue"
begin
  raise MyException.new("Variavel nula") unless  @var_rescue
  puts @var_rescue
rescue MyException => e
  puts e.message
end

puts "Exemplo com retry"
begin
  raise MyException.new("Variavel nula") unless  @var_rescue
  puts @var_rescue
rescue MyException => e
  @var_rescue = "Agora definido"
  retry
end

