##
## A Study in Andrew Studuying Keith
## Performance Embellishments
##



##
##  Define Pulse 5:00

define :pulse do
  # play @ 5:00
  ##| dur = 0.2 + rand(0.5)
  ##| play 60, amp: cosramp2.tick, duration: dur
  
  # modify @ 7:16
  play 48, amp: cosramp2.tick, duration: (0.2 * rand(0.5))
  play 36, amp: cosramp2.tick, duration: (0.2 * rand(0.5))
  
end


define :_runs_ do |pitch, leap, dur|
  puts "inside of _runs_ *****"
  
  pc = pitch_class pitch
  
  if pc == 0
    volume = rand(0.7) + 0.3
  else
    volume = rand(0.2) + 0.2
  end
  
  play pitch, amp: volume, duration: dur
  
  if pc == 0 and rand > 0.3
    return
  else
    sleep 0.1
    next_pitch = pc_relative pitch, leap, (scale 0, :aeolian).take(7)
    leap *= -1 if rand > 0.8
    
    _runs_ next_pitch,leap,dur
  end
end


##
## Define Runs 6:54
##

live_loop :play_runs do
  values = sync :runs
  puts "calling _runs_ with, #{values[:pitch]}, #{values[:leap]}, #{values[:dur]}"
  _runs_ values[:pitch], values[:leap], values[:dur]
  
end


use_random_seed 100 ##21 ##8 ##10

10.times do
  cue :runs, pitch: 60, leap: [-2,-1,1,2,3,4].choose, dur: [0.25,0.125].choose
  puts "-=-=-=-=-=-=-=-=-="
  sleep 2
end

stop



