
class SonicPi::Note
  
  def pc
    self.midi_note % 12
  end
  
  
end

class SonicPi::Core::RingVector
  def pc
    """
    return the pitch class of each note in the ring
    """
    return self.map{|el| el % 12 }
  end
  
  def pc? (n)
    """
    return true if any notes in the ring are in the pitch class of n
    """
    self.any? {|el| el % 12 == n % 12 }
  end
  
  
end



##| define :pc do |p|
##|   p % 12
##| end

define :pc? do |p1,p2|
  p1 % 12 == p2 % 12
end


define :rand_pc do |lo, hi, mode|
  ##| puts "find random pc in range:: ", lo, hi, "pc:: ", pc
  filteredRange =  (range lo, hi, inclusive: false).to_a.select do |p|
    mode.pc? p
  end
  ##| puts "\tfilteredRange = #{filteredRange} "
  filteredRange.choose
end

##| puts rand_pc 2,11, (ring 0,3,7)
##| stop

define :make_chord do |lo, up, num , notes|
  """
take the range and find pitches that match pc
within the range. Return num notes
"""
  pc = notes.pc
  ##| puts "make_chord from #{pc}"
  mychord = ring  #[]
  ##| hack to copy pc so we don't alter it
  mypc = pc.to_a - []
  l = lo
  u = up
  
  num.times do
    rng = u - l
    gap = rng / num
    
    pitch = rand_pc l, l+gap, pc
    
    #try the whole range for a pitch if we didn't get one in the window
    pitch = rand_pc l, u, pc if pitch.nil?
    
    mychord = mychord.push(pitch) if not pitch.nil?
    
    #remove pitch from pc if it exists
    ##| puts "pitch = #{pitch}, pc = #{pc}"
    if not pitch.nil? then
      ##| puts "deleting pitch, #{pitch} from #{pc}"
      pc = pc_delete pc, pitch
      ##| puts "...resulting in pitch class of : #{pc}"
    end
    ##| puts "pc= #{pc}"
    #update window
    l += gap
  end
  
  puts ":make_chord => #{mychord}"
  
  return mychord
  
end

pc = (scale 0, :aeolian).take 7
make_chord 50, 70, 2, pc


define :pc_ivl do |degree, mode, num = 3|
  """
return the pitch class for the chord degree passed in
"""
  return (chord_degree degree, 0, mode, num).pc
end




define :pc_relative do |pitch, offset, mode|
  """
given a note; if the note is in the group then return
the pitch that is offset positions away from note; if offset pushes
beyond the max or min of mode then the note in the proper octave will be 
returned.
  """
  
  puts "got here, pc_relative with mode = #{mode}"
  
  return pitch if offset == 0
  step = offset > 0 ? 1 : -1
  
  p = pitch.to_i #this way we can handle symbols
  cnt = 0
  
  while cnt != offset.abs do
      p += step
      cnt += 1 if mode.pc? p
      ##| puts "got 1 #{p}" if mode.pc? p
    end
    return p
    
  end ## BUG in SonicPi formatting; this is the end of the method
  
  
  
  
  
  define :pc_delete do |aRing, pitch|
    """
given a mode return the mode with any pitches
in the same pitch class as pitch removed
"""
    
    arr = aRing.pc.to_a.delete_if{ |p|  p == pitch % 12 }
    
    return SonicPi::Core::RingVector.new arr
    
  end
  
  ##| scl = (scale 0, :aeolian ).take 7
  ##| scl_ =  pc_delete(scl, 50)
  ##| puts scl, scl_
  
  
  