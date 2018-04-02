# Welcome to Sonic Pi v3.0.2-dev

# A Study in Andrew Studying Keith,
# Composition
#



# performance starts at 2:00
#
#
# general idea: ???
#
use_bpm 110
use_random_seed 50

use_midi_defaults port:"loopbe_internal_midi", velocity: 75
use_synth :tri



currChord = :i


live_loop :metro8 do
  cue :metro8
  sleep 0.5
end



##
## Parameters for shaping the envelope
##

## percent of duration allocated to sustain
env = 0.5
## (0,1] - lower is more space between notes; staccato
breath = 1.0


define :play_chords do |notes, dur, v|
  """ DEPRECATED; the idea is to have an API for playing so that we can
switch between synths and midi easy; will come back to this"""
  puts "chord #{notes}, dur=#{dur}, vel=#{v}"
  notes.each do |n|
    play n, duration: dur, amp: v * 1.0
    ##| midi_note_on n, vel_f: v
    ##| midi n, sustain: dur, vel_f: v
    ##| play n, sustain: dur
  end
end

current_degree = :i

## Part 1
## begins @ 2:01
##
##| live_loop :piece do
##|   chords_part1 current_degree, 3
##|   current_degree = next_degree current_degree

##|   current_degree = { :i => (ring :vii),
##|                      :vii => (ring :i)
##|                      } [current_degree].choose

##| end


## Part 2
## modify tune @3:01
##live_loop :piece do
##|   chords_part2 current_degree, [1,2,3].choose


##|   current_degree = { :i => (ring :vii),
##|                      :vii => (ring :i)
##|                      } [current_degree].choose
##| end



## Part 3
## modify tune @3:22
##
##| live_loop :piece do
##|   duration = [1,2,3].choose
##|   chords_part3 current_degree, duration


##|   current_degree = { :i => (ring :vii),
##|                      :vii => (ring :i, :v),
##|                      :v => (ring :i)
##|                      } [current_degree].choose
##| end


## Part 4
## modify tune @4:00
##
##| live_loop :piece do
##|   duration = [1,2,3].choose
##|   chords_part4 current_degree, duration


##|   current_degree = { :i => (ring :vii),
##|                      :vii => (ring :i, :v),
##|                      :v => (ring :i, :vi),
##|                      :vi => (ring :ii),
##|                      :ii => (ring :v, :vii)
##|                      } [current_degree].choose
##| end


##| add pulse @5:00
##
live_loop :play_pulse do
  stop
  sync :metro8
  puts "PULSE"
  pulse
  sleep 0.1
end


## Part 5
## modify tune @5:19
##
live_loop :piece do
  duration = [1,2,3].choose
  chords_part5 current_degree, duration
  
  
  current_degree = { :i => (ring :vii),
                     :vii => (ring :i, :v),
                     :v => (ring :i, :vi),
                     :vi => (ring :ii),
                     :ii => (ring :v, :vii)
                     } [current_degree].choose
end

