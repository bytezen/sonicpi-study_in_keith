# Welcome to Sonic Pi v3.0.2-dev

# A Study in Keith, Part 1
#

# performance starts at 2:00
#
#
# general idea: ???
#

use_midi_defaults port:"loopbe_internal_midi", velocity: 75
use_bpm 110

progression = { :i => (ring :vii),
                :vii => (ring :i )
                }

defonce :c_progression do
  progression.keys
end


live_loop :metronome do
  cue :metro
  sleep 1
end

define :chords do |notes, dur, v|
  puts "chord #{notes}, dur=#{dur}, vel=#{v}"
  notes.each do |n|
    ##| play n, duration: dur, amp: v * 1.0
    ##| midi_note_on n, vel_f: v
    midi n, sustain: dur, vel_f: v
    ##| play n, sustain: dur
  end
  
end


current_degree = :i
use_random_seed 41


live_loop :part1 do
  dur = 3
  puts current_degree
  next_pc = chord_degree progression[current_degree].choose, 0, :aeolian, 3
  pitches = make_chord 50, 70, 2, next_pc
  volume = (50.0 * Math.cos((vt + beat) * Math::PI) + 60) / 110
  
  chords pitches, dur, volume
  
  sleep (1.0 * dur)
  
  ##| pitches.each do |n|
  ##|   midi_note_off n, vel_f: volume
  ##| end
  ##| sleep ( 0.5 * dur )
  
  
  current_degree = c_progression.choose
end


