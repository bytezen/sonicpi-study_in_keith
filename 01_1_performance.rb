

define :pc do |p|
  p % 12
end

define :rand_pc do |lo, hi, pc|
  ##| puts "find random pc in range:: ", lo, hi, "pc:: ", pc
  
  
  foo =  (range lo, hi).to_a.select{|x|
    pc.include? (pc x)
  }
  
  ret = foo.choose
  ##| puts "....found: ", ret
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
    
    if not p.nil? then
      #add the pitch to the chord
      mychord.push p
      #remove the head of the pitch interval
      mypc.delete (pc p)
      ##| puts "pushing to the new chord", p
      ##| puts " mypc after deleting = ", mypc
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
##| ----------
##| PERFORMANCE
##| ----------
use_random_seed 99
define :body do |notes, dur|
  res = make_chord 50,70, 2, notes
  ##| puts res
  res.each { |n| puts (note_info n), (pc n), n }
  vol = 0.5 + 0.2 * Math.cos(1.0 * beat * 3.1459)
  play_chord res, amp: vol, release: dur
  sleep 0.5 * dur
end

ivl = pc_ivl :i, :aeolian
##| puts ivl


use_synth :piano

notesmatrix = {:i => [:vii],
               :vii => [:i]}
deg = :i

live_loop :cycle do
  body (pc_ivl deg, :aeolian).to_a, 3.0 #ivl.to_a, 3.0 #(pc_ivl :i, :aeolian), 3.0
  deg = notesmatrix[deg].choose
  comment do
    res = make_chord 50,70, 2,  (ring [0,3,7],[10,2,5]).tick
    puts res, beat, vt
    ##| vol = 0.5 + 0.2 * Math.cos( 0.00625* beat * 2 * 3.1459)
    vol = 0.5 + 0.2 * Math.cos( 1.0 * beat * 3.1459)
    puts "V=",vol
    play_chord res, amp: vol, release: 3.0 #, attack: 1.0 # (rand * 1.5)
    sleep 1.5
  end
end











