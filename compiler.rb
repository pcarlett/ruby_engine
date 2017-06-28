#!/usr/bin/env ruby

require 'open3'

class Compiler

   def cleanAll
      Open3.popen3("make clean -C ../edf-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "EDF Libraries Cleaning Complete."
      end
      Open3.popen3("make clean -C ../prio-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "FPS Libraries Cleaning Complete."
      end
   end

   def compileLibs
      Open3.popen3("make libs -C ../edf-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "EDF Libs Compilation Complete."
      end
      Open3.popen3("make libs -C ../prio-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "FPS Libs Compilation Complete."
      end
   end

   def compileUnit unit
      Open3.popen3("make " + unit + " -C ../edf-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "EDF Unit01 Compilation Complete."
      end
      Open3.popen3("make " + unit + " -C ../prio-ravenscar") do |stdin, stdout, stderr, thread|
         thread.value
         puts "FPS Unit01 Compilation Complete."
      end
   end

end
