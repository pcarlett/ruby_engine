#!/usr/bin/env ruby

class compiler

   def compileLibs
      Open3.popen3("make libs -C ../ravenscar-edf") do |stdin, stdout, stderr, thread|
         thread.value
         puts "EDF Libs Compilation Complete."
      end
      Open3.popen3("make libs -C ../prio-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "FPS Libs Compilation Complete."
      end
   end

   def compileUnit(unit)
      Open3.popen3("make " + unit + " -C ../ravenscar-edf") do |stdin, stdout, stderr, thread|
         thread.value
         puts "EDF Unit01 Compilation Complete."
      end
      Open3.popen3("make " + unit + " -C ../prio-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "FPS Unit01 Compilation Complete."
      end
   end

end
