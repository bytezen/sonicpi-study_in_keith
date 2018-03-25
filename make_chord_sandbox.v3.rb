# Welcome to Sonic Pi v2.11.1

hmm = {:i => ring(:vii),
       :vii => ring(:i)
       }

use_random_seed 11022
puts hmm[:vii].choose

puts chord_degree :vii, 0, :minor