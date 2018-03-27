# Welcome to Sonic Pi v3.0.2-dev

# sketchbook
# Testing the ramp settings for A Study in Andrew

define :radians do |d|
  d * Math::PI / 180
end

puts (radians 30)
puts Math.cos(4036/1 * Math::PI)

use_bpm 110

10.times do
  cosramp = 20.0 * Math.cos((vt + beat) * Math::PI) + 50
  puts vt, beat, cosramp
  sleep 3 ##rand * 4 + 1
end

# testing the midi connection port setting for FL Studio
use_midi_defaults port:"loopbe_internal_midi", channel: 1

midi 48, sustain: 0.25