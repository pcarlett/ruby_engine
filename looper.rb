#!/usr/bin/env ruby

require_relative 'compiler'
require_relative 'generator'

class Looper

   # def initialize
   #    @compiler = Compiler.new
   # end

   def testSets_withBlock loops, mode
      i=1;
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset_withBlock mode
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

   def testSets loops, mode, type
      i=1;
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generateDataset mode, type
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

   #### DEBUGGED
   def looperForLocalTests loops, mode, type
      i=1;
      compiler = Compiler.new
      puts "0) Cleaning Environment."
      compiler.cleanAll
      puts "0) Compiling Libraries."
      compiler.compileLibs
      puts "\n"
      loops.times do
         generator = Generator.new
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS = generator.generateDataset mode, type
         puts "#{i}/#{loops}) Dataset Generated. Total: #{totalTasks}."
         puts "Shorts: #{short}\t Mids: #{mid}\t Long: #{long}"
         generator.datasetReplacement timeStamp
         puts "#{i}/#{loops}) Dataset Replaced."
         @compiler.compileUnit unit01
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

   def looperForLocalTests_withBlock loops, mode, type
      i=1;
      puts "0) Cleaning Environment."
      cleanAll
      puts "0) Compiling Libraries."
      compileLibs
      puts "\n"
      loops.times do
         timeStamp, totalTasks, short, mid, long, feasibilityEDF,
         maxLoadEDF, feasibilityFPS, maxPrio, minDead = generateDataset_withBlock mode, type
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

   def cleaner (argument)
      timeStamp = ((Time.now).strftime("%Y-%m-%d %H:%M:%S.%6L")).gsub! " ", "_"
      Open3.popen3("mv ../results.csv history_data/#{timeStamp}_#{argument}.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace2/results.csv >> ../../workspace/ruby_engine/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace2/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace3/results.csv >> ../../workspace/ruby_engine/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace3/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cat ../../workspace4/results.csv >> ../../workspace/ruby_engine/history_data/#{timeStamp}_#{argument}.csv; rm ../../workspace4/results.csv") do |stdin, stdout, stderr, thread|
         thread.value
      end
      puts "Backup Done. Cleaning Operations Terminated."
   end

   def cloneIstances
      Open3.popen3("cp *.rb ../../workspace2/ruby_engine/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cp *.rb ../../workspace3/ruby_engine/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      Open3.popen3("cp *.rb ../../workspace4/ruby_engine/") do |stdin, stdout, stderr, thread|
         thread.value
      end
      puts "Programs Duplicated."
   end

end
