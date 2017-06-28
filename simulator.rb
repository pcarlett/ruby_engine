require 'open3'

class Simulator

   def execGlobalTestLocal str
      # Executes a single test for the EDF environment
      execs = deads = preem = 0
      a = Time.now
      hash_dead = Hash.new
      hash_exec = Hash.new
      hash_map = Hash.new
      # "tsim-leon ../edf-ravenscar/unit01"
      # "tsim-leon ../prio-ravenscar/unit01"
      Open3.popen3 (str) do |stdin, stdout, stderr, thread|
         i = 0
         Thread.new do
               stdout.each do |string|
                  # if (Time.now - a) > 2 then
                  #    Process.kill("KILL",thread.pid)
                  # end
                  t = (i / 200).to_i
                  print "\r#{t}% achieved..."
                  l = string.split(";")
                  # puts "#{l[0]} -- #{l[1]} -- #{l[2]} "
                  if l[0].include?"Setting" then
                     hash_map[l[4].chomp] = l[1].chomp
                     hash_dead[l[4].chomp] = 0
                     hash_exec[l[4].chomp] = 0
                  end
                  if l[0].include?"EXECUTED" then execs += 1; hash_exec[l[2].chomp] += 1 end
                  if l[0].include?"PREEMPT" then preem += 1 end #; hash[l[1]] += 1 end
                  if l[0].include?"DEADLINE" then deads += 1; hash_dead[l[2].chomp] += 1 end
                  i += 1
            end
         end
         stdin.puts "go"
         stdin.close
         Thread.new do
            stderr.each do |s|
               puts s
            end
         end
         thread.value
      end
      b = Time.now
      puts "\nExecution Time: #{b-a}"
      return execs, deads, preem, hash_dead, hash_map, hash_exec
   end

   def execGlobalTestLocal_withBlock str
      # Executes a single test for the EDF environment
      edf_execs = edf_deads = edf_preem = 0
      a = Time.now
      hash = Hash.new
      Open3.popen3 (str) do |stdin, stdout, stderr, thread|
         i = 0
         Thread.new do
            stdout.each do |str|
               if (Time.now - a) > 2 then
                  Process.kill("KILL",thread.pid)
               end
               t = (i / 200).to_i
               print "\r#{t}% achieved..."
               l = str.split(";")
               if l[0].include?"Setting" then hash[l[2]] = 0 end
               if l[0].include?"EXECUTED" then edf_execs += 1 end #; hash[l[1]] += 1 end
               if l[0].include?"PREEMPT" then edf_preem += 1 end #; hash[l[1]] += 1 end
               if l[0].include?"DEADLINE" then edf_deads += 1; hash[l[2]] += 1 end
               i += 1
            end
         end
         stdin.puts "go"
         stdin.close
         Thread.new do
            stderr.each do |s|
               puts s
            end
         end
         thread.value
      end
      b = Time.now
      puts "\nEDF Time: #{b-a}"
      return edf_execs, edf_deads, edf_preem, hash
   end

   def uploadExecsToRemote
      Net::SCP.start("ebano.datsi.fi.upm.es", "mbordin", :password => 'pa6ahShi') do |scp|
         scp.upload! "../edf-ravenscar/unit01", "raven_bench/unit01_edf"
         scp.upload! "../prio-ravenscar/unit01", "raven_bench/unit01_fps"
         puts "EDF Unit01 Upload Completed."
      end
   end

end
