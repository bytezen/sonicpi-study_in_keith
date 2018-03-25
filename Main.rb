



##| ----------
##| PERFORMANCE
##| ----------
use_random_seed 1002
use_synth :beep

##| tune @2:00
define :movement1 do |deg, dur|
  scl = (pc_ivl deg, :aeolian)
  notes = make_chord 50,70, 2, scl
  
  notes.each { |n| puts (note_info n), n }
  vol = 0.5 + 0.2 * Math.cos(2.0 * beat * 3.1459)
  play_chord notes, amp: vol, duration: dur, release: 0.5
  sleep dur * 0.5
end


##| tune @3:01
define :movement2 do |deg, dur|
  scl = (pc_ivl deg, :aeolian)#.to_a
  notes = make_chord 50,70, 2, scl
  
  dur = 3.0 if deg == :i
  
  dur1 = dur * (rrand 0.5, 1.0)
  dur2 = dur - dur1
  
  vol = 0.5 + 0.2 * Math.cos(2.0 * beat * 3.1459)
  puts "dur2 = #{dur2}" if dur2 > 0
  notes.each do |n|
    puts (note_info n), n
    play n, amp: vol, duration: dur1, release: 0.2
    
  end
  
  ##| play_chord notes, amp: vol, release: dur1
  
  if dur2 > 0 then
    sleep dur1
    notes.each do |n|
      shift_value = [-2, -1,1,2].choose
      relative_n = pc_relative n, shift_value, (scale 0,:aeolian).take(7)
      puts (note_info relative_n), relative_n, shift_value
      
      play relative_n, amp: vol, duration: dur2
    end
  end
  
  ## after the first note is over then play the same note relative shifted randomly
  ## for dur2 length of time
  #move the note randomly but quantize to the scale
  
  sleep 0.5 * dur
  
end


live_loop :part1 do
  movement1 :i, 3
end



## notes matrix movement 2
notesmatrix = {:i => [:vii],
               :vii => [:i]}

deg = :i

comment do
  live_loop :part2 do
    movement2 deg, rrand_i(1,3)
    deg = notesmatrix[deg].choose
    print deg
  end
end

stop

##|     (define chords
##|      (lambda (time degree dur)
##|       (if (member degree '(i)) (set! dur 3.0))
##|     (println time degree dur)
##|     (for-each (lambda (p)
##|                 (let* ((dur1 (* dur (random '(0.5 1))))
##|          (dur2 (- dur dur1)))
##|          ;;                  (play-midi-note (*metro* time) *midi-out* p
##|                               (play-note time inst pitch vol dur . args)
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




comment do
  live_loop :cycle do
    body deg, 3.0 #(pc_ivl deg, :aeolian).to_a, 3.0 #ivl.to_a, 3.0 #(pc_ivl :i, :aeolian), 3.0
    deg = notesmatrix[deg].choose
  end
end












