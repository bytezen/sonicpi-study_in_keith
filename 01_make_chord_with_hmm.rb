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
  mypc = pc.to_a - []
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


hmm = {:i => ring(:vii),
       :vii => ring(:i)
       }


define :_play do |deg, dur|
  ns = chord_degree deg, 0, :minor, 3
  c = make_chord 50, 70, 2, ns
  d = dur
  d = 3 if deg == :i
  play_chord c, sustain: d, amp: 0.8
  ##| c.each do |x|
  ##|   puts x
  ##|   play xx, sustain: d, amp: 0.8, cutoff: 80
  ##| end
  sleep dur
  
end

deg = :i
loop do
  use_synth :piano
  _play deg, 1
  deg = hmm[deg].choose
  sleep 1
end


with_fx :reverb do
  live_loop :cycle do
    res = make_chord 50,76, 2, [0,3,7,9]
    puts res
    vol = 0.5 + 0.2 * Math.cos( 0.00625* beat * 2 * 3.1459)
    puts "V=",vol
    play_chord res, amp: vol, release: 1.0 #, attack: 1.0 # (rand * 1.5)
    sleep 0.5
  end
end

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