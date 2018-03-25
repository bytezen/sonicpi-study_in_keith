
class SonicPi::Note
  
  def pc
    self.midi_note % 12
  end
  
  
end

class SonicPi::Core::RingVector
  def pc
    return self.map{|el| el % 12 }
  end
  
  def pc? (n)
    self.any? {|el| el % 12 == n % 12 }
  end
  
  ##| def del (n)
  ##|   if not self.index(n).nil? then
  ##|     arr = self.to_a
  ##|     puts arr
  ##|     arr.delete_if { |p| p % 12 == n % 12}
  ##|     puts arr
  ##|     return SonicPi::Core::RingVector.new(arr)
  ##|   end
  ##| end
end
