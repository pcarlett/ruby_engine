#!/usr/bin/env ruby

require_relative 'helper'
require 'open3'
require_relative 'simulator'
require_relative 'recorder'

class Engine

   def testSets loops, mode, type, nums
      i=1;
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset mode, type, nums
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         datasetReplacement timeStamp
         puts "#{i}/#{loops}) Dataset Replaced."
         puts "#{i}/#{loops}) Testing EDF Dataset: EDF Feasibility: "\
              "#{feasibilityEDF.to_s.upcase} with: #{maxLoadEDF} %."
         puts "#{i}/#{loops}) Testing FPS Dataset: FPS Feasibility: "\
              "#{feasibilityFPS.to_s.upcase}."
         puts "#{i}/#{loops}) Test Ended Correctly."
         puts "\n"
         i +=1
      end
   end

   def testSets_withBlock loops, mode, type, nums
      i=1;
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset_withBlock mode, type, nums
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         puts "#{i}/#{loops}) Testing EDF Dataset: EDF Feasibility: "\
              "#{feasibilityEDF.to_s.upcase} with: #{maxLoadEDF} %."
         puts "#{i}/#{loops}) Testing FPS Dataset: FPS Feasibility: "\
              "#{feasibilityFPS.to_s.upcase}."
         puts "#{i}/#{loops}) Test Ended Correctly."
         puts "\n"
         i +=1
      end
   end


   def looperForLocalTests loops, mode, type, nums
      i=1;
      puts "0) Cleaning Environment."
      cleanAll
      puts "0) Compiling Libraries."
      compileLibs
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset mode, type, nums
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         datasetReplacement timeStamp
         puts "#{i}/#{loops}) Dataset Replaced."
         compileUnit01
         puts "#{i}/#{loops}) Units Compiled."
         puts "#{i}/#{loops}) Registering Data: EDF Feasibility: #{feasibilityEDF.to_s.upcase} "\
         "with: #{maxLoadEDF} %."
         edf_execs, edf_deads, edf_preem, hash_edf_dead, hash_edf_map, hash_edf_exec =
            execGlobalTestLocal "tsim-leon ../ravenscar-edf/unit01"
         puts "#{i}/#{loops}) EDF Test Completed."
         puts "#{i}/#{loops}) Execs: #{edf_execs}\t Deads: #{edf_deads}\t Preemps: #{edf_preem}"
         puts "#{i}/#{loops}) Registering Data: FPS Feasibility: #{feasibilityFPS.to_s.upcase}."
         fps_execs, fps_deads, fps_preem, hash_fps_dead, hash_fps_map, hash_fps_exec =
            execGlobalTestLocal "tsim-leon ../prio-ravenscar/unit01"
         puts "#{i}/#{loops}) FPS Test Completed."
         puts "#{i}/#{loops}) Execs: #{fps_execs}\t Deads: #{fps_deads}\t Preemps: #{fps_preem}"
         dataRegistration timeStamp, mode, totalTasks, short, mid, long,
            feasibilityEDF, maxLoadEDF, feasibilityFPS, edf_execs, edf_deads,
            edf_preem, fps_execs, fps_deads, fps_preem, hash_edf_dead, hash_edf_map,
            hash_edf_exec, hash_fps_dead, hash_fps_map, hash_fps_exec
         puts "#{i}/#{loops}) Data Registered Correctly."
         puts "\n"
         i +=1
      end
   end

   def looperForLocalTests_short
      puts "0) Cleaning Environment."
      cleanAll
      puts "0) Compiling Libraries."
      compileLibs
      compileUnit05
      puts "0) Units Compiled."
      edf_execs, edf_deads, edf_preem, hash_fps =
         execGlobalTestLocal_withBlock "tsim-leon ../ravenscar-edf/unit05"
      puts "0) EDF Test Completed."
      puts "0) Execs: #{edf_execs}\t Deads: #{edf_deads}\t Preemps: #{edf_preem}"
      fps_execs, fps_deads, fps_preem, hash_fps =
         execGlobalTestLocal_withBlock "tsim-leon ../prio-ravenscar/unit05"
      puts "0) FPS Test Completed."
      puts "0) Execs: #{fps_execs}\t Deads: #{fps_deads}\t Preemps: #{fps_preem}"
      dataRegistration_short edf_execs, edf_deads, edf_preem, fps_execs, fps_deads, fps_preem
      puts "0) Data Registered Correctly."
      puts "\n"
   end

   def looperForLocalTests_withBlock loops, mode, type, nums
      i=1;
      puts "0) Cleaning Environment."
      cleanAll
      puts "0) Compiling Libraries."
      compileLibs
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS, maxPrio, minDead = generateDataset_withBlock mode, type, nums
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         datasetReplacement_withBlock timeStamp, maxPrio, minDead
         puts "#{i}/#{loops}) Dataset Replaced."
         compileUnit05
         puts "#{i}/#{loops}) Units Compiled."
         puts "#{i}/#{loops}) Registering Data: EDF Feasibility: #{feasibilityEDF.to_s.upcase} "\
         "with: #{maxLoadEDF} %."
         edf_execs, edf_deads, edf_preem, hash_edf =
            execGlobalTestLocal_withBlock "tsim-leon ../ravenscar-edf/unit05"
         puts "#{i}/#{loops}) EDF Test Completed."
         puts "#{i}/#{loops}) Execs: #{edf_execs}\t Deads: #{edf_deads}\t Preemps: #{edf_preem}"
         puts "#{i}/#{loops}) Registering Data: FPS Feasibility: #{feasibilityFPS.to_s.upcase}."
         fps_execs, fps_deads, fps_preem, hash_fps =
            execGlobalTestLocal_withBlock "tsim-leon ../prio-ravenscar/unit05"
         puts "#{i}/#{loops}) FPS Test Completed."
         puts "#{i}/#{loops}) Execs: #{fps_execs}\t Deads: #{fps_deads}\t Preemps: #{fps_preem}"
         dataRegistration timeStamp, mode, totalTasks, short, mid, long,
         feasibilityEDF, maxLoadEDF, feasibilityFPS, edf_execs,
         edf_deads, edf_preem, fps_execs, fps_deads, fps_preem
         puts "#{i}/#{loops}) Data Registered Correctly."
         puts "\n"
         i +=1
      end
   end

   def looperForRemoteTests loops, mode, type, nums
      i=1;
      puts "0) Cleaning Environment."
      cleanAll
      puts "0) Compiling Libraries."
      compileLibs
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset mode, type, nums
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         datasetReplacement timeStamp
         puts "#{i}/#{loops}) Dataset Replaced."
         compileUnits
         puts "#{i}/#{loops}) Units Compiled."
         puts "#{i}/#{loops}) Uploading Unit01 to Remote Server."
         uploadExecsToRemote
         puts "#{i}/#{loops}) Registering Data: EDF Feasibility: #{feasibilityEDF.to_s.upcase} "\
         "with: #{maxLoadEDF} %."
         edf_execs, edf_deads, edf_preem = execEDFTestRemote
         puts "#{i}/#{loops}) Testing Registered Data..."
         puts "#{i}/#{loops}) EDF Test Completed."
         puts "#{i}/#{loops}) Execs: #{edf_execs}\t Deads: #{edf_deads}\t Preemps: #{edf_preem}"
         puts "#{i}/#{loops}) Registering Data: FPS Feasibility: #{feasibilityFPS.to_s.upcase}."
         fps_execs, fps_deads, fps_preem = execFPSTestRemote
         puts "#{i}/#{loops}) FPS Test Completed."
         puts "#{i}/#{loops}) Execs: #{fps_execs}\t Deads: #{fps_deads}\t Preemps: #{fps_preem}"
         dataRegistration timeStamp, mode, totalTasks, short, mid, long,
         feasibilityEDF, maxLoadEDF, feasibilityFPS, edf_execs, edf_deads,
         edf_preem, hash_edf, fps_execs, fps_deads, fps_preem, hash_fps
         puts "#{i}/#{loops}) Data Registered Correctly."
         puts "\n"
         i +=1
      end
   end

   def cleaner (argument)
      timeStamp = ((Time.now).strftime("%Y-%m-%d %H:%M:%S.%6L")).gsub! " ", "_"
      Open3.popen3("mv ../results.csv history_data/#{timeStamp}_#{argument}.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace2/results.csv >> ../../workspace/autoruby/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace2/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace3/results.csv >> ../../workspace/autoruby/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace3/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace4/results.csv >> ../../workspace/autoruby/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace4/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      puts "Backup Done. Cleaning Operations Terminated."
   end

   def cloneIstances
      Open3.popen3("cp *.rb ../../workspace2/autoruby/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cp *.rb ../../workspace3/autoruby/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cp *.rb ../../workspace4/autoruby/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      puts "Programs Duplicated."
end

engine = Engine.new
case ARGV[0]
when "-exec"
   engine.looperForLocalTests_short
when "-l"
   if ARGV[3].nil? || ARGV[5].nil? then
      printHelp
   else
      engine.looperForLocalTests ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
   end
when "-d"
   if ARGV[3].nil? || ARGV[5].nil? then
      printHelp
   else
      engine.looperForLocalTests_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
   end
when "-r"
   if ARGV[3].nil? || ARGV[5].nil? then
      printHelp
   else
      engine.looperForRemoteTests ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
   end
when "-t"
   if ARGV[3].nil? || ARGV[5].nil? then
      printHelp
   else
      engine.testSets ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
   end
when "-tb"
   if ARGV[3].nil? || ARGV[5].nil? then
      printHelp
   else
      engine.testSets_withBlock ARGV[1].to_i, ARGV[3].to_s, ARGV[5].to_s, ARGV[6].to_s
   end
when "-a"
   engine.cleaner ARGV[1].to_s
when "-c"
   engine.cloneIstances
else
   helper.printHelp
end
