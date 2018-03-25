

"""
x = chord_degree :i, :c3, :ionian, 3
puts x
puts x.pc

y = x.pc
puts x, y
puts (note_info :c4)
assert x.pc?((note_info :c4).midi_note)
"""

scl = scale 0, :lydian
puts scl
foo = relative 60, -1, scl
puts foo


stop

##| pitch = :e4
##| puts pitch.to_i
##| puts (relative pitch, -2, :ionian)
##| note = SonicPi::Note.new
##| puts note
##| stop


##| class SonicPi::Note
##|   def grr
##|     "boo yah"
##|   end
##| end
use_random_seed 20398
##| pc = scale 0, :aeolian
##| 10.times do
##|   ##| randomp = rand_pc 60, 72, pc
##|   ##| puts randomp
##|   chrd = make_chord 50, 70, 2, pc
##|   puts chrd
##| end
##| puts pc

##| stop


##| ----------
##| PERFORMANCE
##| ----------
use_random_seed 99
use_synth :fm

##| tune @2:00
define :body do |deg, dur|
  notes = (pc_ivl deg, :aeolian).to_a
  res = make_chord 50,70, 2, notes
  
  res.each { |n| puts (note_info n), (pc n), n }
  vol = 0.5 + 0.2 * Math.cos(1.0 * beat * 3.1459)
  play_chord res, amp: vol, release: dur
  sleep dur * 0.5
end


##| tune @3:01
define :body2 do |deg, dur|
  notes = (pc_ivl deg, :aeolian).to_a
  res = make_chord 50,70, 2, notes
  
  dur = 3.0 if deg == :i
  dur1 = dur * (rrand 0.5, 1.0)
  dur2 = dur - dur1
  ##| puts res
  res.each { |n| puts (note_info n), (pc n), n }
  
  vol = 0.5 + 0.2 * Math.cos(1.0 * beat * 3.1459)
  play_chord res, amp: vol, release: dur1
  
  #move the note randomly but quantize to the scale
  
  sleep 0.5 * dur
  
  
  ##|     (define chords
  ##|      (lambda (time degree dur)
  ##|       (if (member degree '(i)) (set! dur 3.0))
  ##|     (println time degree dur)
  ##|     (for-each (lambda (p)
  ##|                 (let* ((dur1 (* dur (random '(0.5 1))))
  ##|          (dur2 (- dur dur1)))
  ##|          ;;                  (play-midi-note (*metro* time) *midi-out* p
  ##|                               (play-note (*metro* time) synth p
  ##|                                (real->integer(+ 50 (* 20 (cos (* pi time)))))
  ##|                                (*metro* 'dur dur1) 0)
  ##|                   (if (> dur2 0)
  ##| ;;                      (play-midi-note (*metro* (+ time dur1)) *midi-out*
  ##|                       (play-note (*metro* (+ time dur1)) synth
  ##|                                       (pc:relative p (random '(-2 -1 1 2))
  ##|                                (pc:scale 0 'aeolian))
  ##|                                       (real->integer (+ 50 (* 20 (cos (* pi (+ time dur1))))))
  ##|                                       (*metro* 'dur dur2) 0 ))))
  
  ##|          (pc:make-chord 50 70 2 (pc:diatonic 0 '- degree)))
  ##|     (callback (*metro* (+ time (* 0.5 dur))) 'chords (+ time dur)
  ##|                                  (random (assoc degree '((i vii)
  ##|                                       (vii i))))
  ##|               (random (list 1 2 3)))))
  
  
end

## ---

##| use_synth ˆ:piano


notesmatrix = {:i => [:vii],
               :vii => [:i]}
deg = :i

live_loop :cycle do
  body deg, 3.0 #(pc_ivl deg, :aeolian).to_a, 3.0 #ivl.to_a, 3.0 #(pc_ivl :i, :aeolian), 3.0
  deg = notesmatrix[deg].choose
end











