#!/usr/bin/env ruby

class helper

   def printHelp
      puts "Please use labels as explained:"
      puts "-l xxx -m zzz -exp kkk yyy: test locally"
      puts "-d xxx -m zzz -exp kkk yyy: test dfp locally with a single protected object"
      puts "-exec: compile and registrer results for a specific test"
      puts "-r xxx -m zzz -exp kkk yyy: test remotely"
      puts "-t xxx -m zzz -exp kkk yyy: peforms a static test without execute it on the simulator"
      puts "-tb xxx -m zzz -exp kkk yyy: test environment with block."
      puts "-a bbb: to clean of the stored results and archive with argument bbb."
      puts "-c to duplicate main Ruby programs in the other workspaces."
      puts ""
      puts "xxx: how many loops to test"
      puts "zzz: what kind of deadlines (i, c, a, m)"
      puts "kkk: what mechanism to construct the sizing (std -> 2^x, mix -> exponential)"
      puts "yyy: kind of experiment (1: fr; 2: sl; 3: lo; 4: sm; 5: so; 6: ml; 7: mo)"
   end

end
