
##| define :pc do |p|
##|   p % 12
##| end

define :pc? do |p1,p2|
  p1 % 12 == p2 % 12
end


define :rand_pc do |lo, hi, pc|
  ##| puts "find random pc in range:: ", lo, hi, "pc:: ", pc
  
  pitches = (range lo, hi).to_a
  filteredRange =  pitches.select do |pitch|
    ##| pc.include? (pc pitch)
    pc.any? { |p| pc? pitch, p }
  end
  
  filteredRange.choose
end

##| puts rand_pc 2,11, [0]
##| stop

define :make_chord do |lo, up, num ,pc|
  """
take the range and find pitches that match pc
within the range. Return num notes
"""
  mychord = []
  ##| hack to copy pc so we don't alter it
  mypc = pc.to_a - []
  l = lo
  u = up
  
  pc.map do ||
      ##| puts "using pitch class: ", mypc
      rng = u - l
    gap = (rng.to_f / num).round
    ##| get random pitch between lower and gap
    p = rand_pc l, (l + gap), mypc
    
    # if p is empty try again over the whole range˜
    if p.nil? then
      ##| puts "p is empty...trying on entire range"
      p = rand_pc l, u, mypc
    end
    ##| puts p, mypc
    
    if not p.nil? then
      #add the pitch to the chord
      mychord.push p
      #remove the head of the pitch interval
      mypc.delete (pc p)
      ##| puts "pushing to the new chord", p
      ##| puts "mypc after deleting = ", mypc
    end
    ##| break if mychord.length == num
    l = l + gap
  end
  
  mychord.shuffle().take num
end



define :pc_ivl do |degree, mode, num = 3|
  (chord_degree degree, 0, mode, num).map do |n|
    pc n
  end
  
end

define :relative do |pitch, offset, mode|
  """
given a note; if the note is in the group then return
the pitch that is offset positions away from note; if offset pushes
beyond the max or min of mode then the note in the proper octave will be 
returned.
  """
  
  octave = pitch.to_i / 12
  octave = (octave - 1) if octave > 0
  scl = octs (octave * 12 ), 2 #scale (octave * 12), mode
  
  
end