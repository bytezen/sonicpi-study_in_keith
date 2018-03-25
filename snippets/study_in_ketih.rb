##| use_random_seed 99

define :pc do |p|
  p % 12
end

define :rand_pc do |lo, hi, pc|
  puts "find random pc in range:: ", lo, hi, "pc:: ", pc
  
  
  foo =  (range lo, hi).to_a.select{|x|
    pc.include? (pc x)
  }
  
  ret = foo.choose
  puts "....found: ", ret
  ret
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
  mypc = pc - []
  l = lo
  u = up
  
  pc.map { ||
    puts "using pitch class: ", mypc
    rng = u - l
    gap = (rng.to_f / num).round
    ##| get random pitch between lower and gap
    p = rand_pc l, (l + gap), mypc
    
    if p.nil? then
      ##| puts "p is empty...trying on entire range"
      # if p is empty try again over the whole range˜
      p = rand_pc l, u, mypc
    end
    
    if not p.nil? then
      #add the pitch to the chord
      #remove the head of the pitch interval
      #
      ##| puts "pushing to the new chord", p
      mychord.push p
      
      mypc.delete (pc p)
      ##| puts " mypc after deleting = ", mypc
      
    end
    
    l = l + gap
  }
  
  mychord
end