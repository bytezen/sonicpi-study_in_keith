use_random_seed 2

define :rand_pc do |lo, hi, pc|
  define :pc do |p|
    p % 12
  end
  puts "rand_pc for: ", lo, hi
  
  foo =  (range lo, hi).to_a.select{|x|
    pc.include? (pc x)
  }
  
  if not foo.nil?
    puts "random_pc", foo
    foo.choose
  end
  
end

##| puts rand_pc 2,20, [0,4,7,9]

define :make_chord do |lo, up, num ,pc|
  """
take the range and find pitches that match pc
within the range. Return num notes
"""
  mychord = []
  mypc = pc - []
  
  rng = up - lo
  gap = (rng.to_f / num).round
  
  pc.map { ||
    # get random pitch between lower and gap
    p = rand_pc lo, (lo + gap), mypc
    puts "random pitch fetch:: ",p
    if p.nil? then
      puts "p is empty...trying on entire range"
      # if p is empty try again over the whole range˜
      p = rand_pc lo, up, mypc
    end
    
    if not p.nil? then
      mychord.push p
      mypc.delete p
    end
  }
  
  mychord
end

res = make_chord 10,20, 3, [1,2,3]
puts res


define :foo do |x,p|
  x - [p]
end

bar = [1,2,3,4]
baz = foo bar,[]

puts bar, baz

##| foo
##| foo "you"


##| puts chord_names
##| puts (chord :M),( chord '7'),(chord 'M7')

##| play_chord (chord :M)