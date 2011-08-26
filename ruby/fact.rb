class Fixnum
  def fact
    tmp = 1 
    (1..self).step{|i| tmp *= i}
    tmp
  end
end
