#!/usr/bin/env ruby

require_relative 'helper'

require_relative 'simulator'
require_relative 'recorder'

#####################################################################
##
##  Main loop:
##
#####################################################################

help = Helper.new

if ARGV[1].nil? || ARGV[3].nil? || ARGV[5].nil? || ARGV[6].nil? then
   help.printHelp
else
   case ARGV[0]
      when "-l"
            engine.looperForLocalTests ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
      when "-d"
            engine.looperForLocalTests_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
      when "-r"
            engine.looperForRemoteTests ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
      when "-t"
            engine.testSets ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
      when "-tb"
            engine.testSets_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
      when "-a"
         engine.cleaner ARGV[1].to_s
      when "-c"
         engine.cloneIstances
      else
         help.printHelp
      end
   end
end
