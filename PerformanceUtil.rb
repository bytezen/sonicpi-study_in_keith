
##| module BytezenExtensions
define :notes_info do |xs|
  ret = xs.map { |x| note_info x }
  ret
end


##| class SonicPi::Note
##|   def pc
##|     self.midi_note % 12
##|   end
##| end


##| class SonicPi::Core::RingVector
##|   def pc
##|     """
##|     return the pitch class of each note in the ring
##|     """
##|     return self.map{|el| el % 12 }
##|   end

##|   def pc? (n)
##|     """
##|     return true if any notes in the ring are in the pitch class of n
##|     """
##|     self.any? {|el| el % 12 == n % 12 }
##|   end


##| end



define :pitch_class do |p|
  """ return the pitch class of an enumeration or a number"""
  
  if p.respond_to?(:map)
    p.map { |x| x % 12 }
  elsif p.respond_to?(:to_i)
    p.to_i % 12
  else
    p % 12
  end
end


define :pc? do |p,pc|
  """ Test for membership of p in pitch class  """
  if pc.respond_to?(:member?)
    return  (pitch_class pc).member?(pitch_class p)
  else
    
    (pitch_class p) == (pitch_class pc)
  end
end


define :pc_rand do |notes,pc|
  """ choose a random note from range that is in pitchclass, pc"""
  
  (pc_filter notes,pc).choose
end


define :pc_filter do |notes, pc|
  """ filter an enumeration of notes returning only those that are in the
pitch class, pc"""
  notes.to_a.select { |x| pc? x, pc }
end



define :pc_delete do |p, pc|
  """ remove pitch from pitchclass. return new pitchclass or
copy of old if the pitchclass does not exist"""
  
  arr = pc.to_a
  
  arr.delete_if { |n| pc? n, p }
  
  return SonicPi::Core::RingVector.new arr
  
end


define :make_chord do |lo, up, num , notes|
  """
take the range and find pitches that match pc
within the range. Return num notes
"""
  pc = pitch_class notes ##.pc
  mychord = []  #[]
  
  l = lo
  u = up
  rng = u - l
  gap = rng / num
  
  num.times do
    ##| puts "\t rnge = ", (u-l)
    
    pitch = pc_rand (range l, l+gap), pc
    #try the whole range for a pitch if we didn't get one in the window
    pitch = pc_rand (range lo, up), pc if pitch.nil?
    
    mychord << pitch if not pitch.nil?
    
    #remove pitch from pc if it exists
    ##| puts "pitch = #{pitch}, pc = #{pc}"
    if not pitch.nil? then
      ##| puts "deleting pitch, #{pitch} from #{pc}"
      pc = pc_delete pitch, pc
      ##| puts "...resulting in pitch class of : #{pc}"
    end
    ##| puts "pc= #{pc}"
    #update window
    l += gap
  end
  
  ##| puts ":make_chord => #{mychord}"
  
  return SonicPi::Core::RingVector.new mychord
  
end



define :pc_relative do |p, offset, pc|
  """ shift a pitch within a offset places within a pitch class"""
  
  
  return p if offset == 0
  
  step = offset > 0 ? 1 : -1
  
  #this way we can handle symbols
  p = p.to_i
  
  cnt = offset.abs
  
  while cnt > 0 do
      p += step
      cnt -= 1 if (pc? p, pc)
    end
    return p
    
  end ## BUG in SonicPi formatting; this is the end of the method
  
  
  