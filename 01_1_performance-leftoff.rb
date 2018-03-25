

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

define :relative do |pitch, offset, mode|
  """
given a note; if the note is in the group then return
the pitch that is offset positions away from note; if offset pushes
beyond the max or min of mode then the note in the proper octave will be 
returned.
  """
  
  octave = pitch.to_i / 12
  octave = (octave - 1) if octave > 0
  scl = octs (octave * 12 ), 2 #scale (octave * 12), mode
  
  
end
pitch = :e4
puts pitch.to_i
puts (relative pitch, -2, :ionian)

stop

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











