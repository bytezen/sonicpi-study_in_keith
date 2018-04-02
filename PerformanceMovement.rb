##
## A Study in Andrew Studying Keith
## PerformanceMovement.rb

pi = 3.145960

##  Set up a ramp using cos
cosramp = []
cosramp_offset = 10000
cosramp_size = 100
cosramp_range = range cosramp_offset, cosramp_offset + cosramp_size

cosramp_range.each do |i|
  wobble = rand(0.5) * [-1,1].choose
  v = 0.5 * Math.cos( (i + wobble) * pi) + 1.0
  cosramp << v
end
cosramp = SonicPi::Core::RingVector.new cosramp


cosramp2 = []
cosramp2_offset = 10000
cosramp2_size = 100
cosramp2_range = range cosramp2_offset, cosramp2_offset + cosramp2_size

cosramp2_range.each do |i|
  wobble = rand(0.5) * [-1,1].choose
  v = 0.5 * Math.cos( (i + wobble) * pi) + [0.75, 0.55, 0.85].choose
  cosramp2 << v
end
cosramp2 = SonicPi::Core::RingVector.new cosramp2


##
##| Part 1 Chords
##


define :chords_part1 do |deg, dur|
  
  next_pc = chord_degree deg, 0, :aeolian, 3
  pitches = make_chord 50, 70, 2, next_pc
  ##| volume = (0.5 * Math.cos((beat) * pi) + 1.0)
  
  pitches.each do |n|
    play n,  sustain: env * breath * dur, release: (1.0 - env) * breath * dur, amp: cosramp.tick
  end
  
  ##| play_chords pitches, dur, volume
  
  sleep (1.0 * dur)
  ##| current_degree = c_progression.choose
end


##
##| Part 2 Chords
##

define :chords_part2 do |deg, dur|
  if deg == :i
    dur = 3.0
  end
  
  puts deg, dur
  
  ## percent of duration allocated to sustain
  env = 0.75
  ## (0,1] - lower is more space between notes; staccato
  breath = 0.95
  
  next_pc = chord_degree deg, 0, :aeolian, 3
  pitches = make_chord 50, 70, 2, next_pc
  ##| volume = (0.5 * Math.cos((beat) * pi) + 1.0)
  volume = cosramp.tick
  volume2 = cosramp.tick
  
  pitches.each do |n|
    dur1 = dur * [0.5, 1.0].choose
    dur2 = dur - dur1
    
    ##| play n, duration: dur1, amp: volume
    play n, sustain: env * breath * dur1, release: (1.0 - env) * breath * dur1, amp: volume
    
    if dur2 > 0
      ##| sleep dur1
      volume2 = (0.5 * Math.cos((beat + dur) * pi) + 1.0)
      shift_n = pc_relative n, [-2, -1, 1, 2].choose, (scale :minor)
      ##| play shift_n, duration: dur2, amp: volume2
      play n, sustain: env * breath * dur2, release: (1.0 - env) * breath * dur2, amp: volume2
    end
  end
  
  sleep dur
  
end


## Work in Progress with Part 3;
## Figured out that I need to use the scheduling feature to play
## Sounds in Sonic Pi

define :chords_part3 do |deg, dur|
  if deg == :i
    dur = [3.0, 6.0].choose
  end
  
  puts deg, dur
  
  ## percent of duration allocated to sustain
  env = [0.8, 0.8].choose
  ## (0,1] - lower is more space between notes; staccato
  breath = [0.90, 0.70].choose
  
  next_pc = chord_degree deg, 0, :aeolian, 3
  pitches = make_chord 50, 70, 2, next_pc
  ##| volume = (0.5 * Math.cos((beat) * pi) + 1.0)
  volume = cosramp.tick
  volume2 = cosramp.tick
  
  ## depending on random duration build up patterns
  pattern1 = []
  pattern2 = []
  dur1 = dur
  dur2 = 0
  
  pitches.each do |n|
    dur1 = dur * [0.5, 1.0].choose
    dur2 = dur - dur1
    
    pattern1 << [n,dur1]
    
    if dur2 > 0
      shift_n = pc_relative n, [-2, -1, 1, 2].choose, (scale :minor)
      pattern2 << [shift_n, dur2]
    end
  end
  
  pattern1.each do |n,d|
    play n, attack: 0.2, sustain: env * breath * d, release: ( 1.0-env) * breath * d, amp: volume
  end
  
  sleep dur1
  
  if pattern2.length > 0
    pattern2.each do |n,d|
      play n, attack: 0.1, sustain: env * breath * d, release: (1.0-env)* breath * d, amp: volume2
    end
    
    sleep dur2
  end
  
end


##
## Chords Part 4
##

define :chords_part4 do |deg, dur|
  if deg == :i
    dur = [3.0, 6.0].choose
  end
  
  puts deg, dur
  
  
  ## percent of duration allocated to sustain
  env = [0.5, 0.5].choose
  ## (0,1] - lower is more space between notes; staccato
  breath = [0.95, 0.95].choose
  
  next_pc = chord_degree deg, 0, :aeolian, 3
  pitches = make_chord 50, 70, 3, next_pc
  ##| volume = (0.5 * Math.cos((beat) * pi) + 1.0)
  volume = cosramp.tick
  volume2 = cosramp.tick
  
  ## play the chord root
  root = pc_rand (range 40,51), (chord_degree deg,0, :minor, 1 )
  play root, sustain: env * breath * dur, release: ( 1.0-env) * breath * dur, amp: volume
  
  ## depending on random duration build up patterns
  pattern1 = []
  pattern2 = []
  dur1 = dur
  dur2 = 0
  
  pitches.each do |n|
    dur1 = dur * [0.5, 1.0].choose
    dur2 = dur - dur1
    
    pattern1 << [n,dur1]
    
    if dur2 > 0
      shift_n = pc_relative n, [-2, -1, 1, 2].choose, (scale :minor)
      pattern2 << [shift_n, dur2]
    end
  end
  
  pattern1.each do |n,d|
    play n, attack: 0.0, sustain: env * breath * d, release: ( 1.0-env) * breath * d, amp: volume
  end
  
  sleep dur1
  
  if pattern2.length > 0
    pattern2.each do |n,d|
      play n, attack: 0.0, sustain: env * breath * d, release: (1.0-env)* breath * d, amp: volume2
    end
    
    sleep dur2
  end
  
end


define :pulse do
  dur = 0.2 + rand(0.5)
  play 60, amp: cosramp2.tick, duration: dur
end


##
## Chords Part 5
##

define :chords_part5 do |deg, dur|
  if deg == :i
    dur = [3.0, 6.0].choose
  end
  
  puts deg, dur
  
  
  ## percent of duration allocated to sustain
  env = [0.5, 0.5].choose
  ## (0,1] - lower is more space between notes; staccato
  breath = [0.95, 0.95].choose
  
  next_pc = chord_degree deg, 0, :aeolian, 3
  
  ##
  if rand > 0.5
    top_pitch = 80
  else
    top_pitch = 70
  end
  
  pitches = make_chord 50, top_pitch, 3, next_pc
  
  ##| volume = (0.5 * Math.cos((beat) * pi) + 1.0)
  volume = cosramp.tick
  volume2 = cosramp.tick
  
  ## play the chord root
  root = pc_rand (range 40,51), (chord_degree deg,0, :minor, 1 )
  play root, sustain: env * breath * dur, release: ( 1.0-env) * breath * dur, amp: volume
  
  ## depending on random duration build up patterns
  pattern1 = []
  pattern2 = []
  dur1 = dur
  dur2 = 0
  
  pitches.each do |n|
    dur1 = dur * [0.5, 1.0].choose
    dur2 = dur - dur1
    
    pattern1 << [n,dur1]
    
    if dur2 > 0
      shift_n = pc_relative n, [-2, -1, 1, 2].choose, (scale :minor)
      pattern2 << [shift_n, dur2]
    end
  end
  
  pattern1.each do |n,d|
    play n, attack: 0.0, sustain: env * breath * d, release: ( 1.0-env) * breath * d, amp: volume
  end
  
  sleep dur1
  
  if pattern2.length > 0
    pattern2.each do |n,d|
      play n, attack: 0.0, sustain: env * breath * d, release: (1.0-env)* breath * d, amp: volume2
    end
    
    sleep dur2
  end
  
end
