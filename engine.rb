#!/usr/bin/env ruby

require_relative 'Helper'
require_relative 'Looper'

#####################################################################
##
##  Main loop:
##
#####################################################################

help = Helper.new
looper = Looper.new

case ARGV[0]
when "-a"
   looper.cleaner ARGV[1].to_s
when "-c"
   looper.cloneIstances
else
   if ARGV[1].nil? || ARGV[3].nil? || ARGV[5].nil? || ARGV[7].nil? then
      help.printHelp
   else
      case ARGV[0]
      when "-l"
            looper.looperForLocalTests ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[7].to_s
      when "-d"
            looper.looperForLocalTests_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[7].to_s
      when "-t"
            looper.testSets ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[7].to_s
      when "-tb"
            looper.testSets_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[7].to_s
      else
         help.printHelp
      end
   end
end