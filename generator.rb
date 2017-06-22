#!/usr/bin/env ruby

require_relative 'basic_task'
require_relative 'parameters_extended'
# require_relative 'parameters_limited'

class Generator
   # It applies RTA algorithm: in this way task periods are computed
   # as power of 2 to perform a quickly computation of the hyperPeriod
   attr_accessor :taskset
   attr_accessor :param

   def initialize
      @taskset = Array.new
      @param = Parameters.new
   end

   def taskTypeNum nums
      # Here we generate numerosity of the taskset so we can create
      # different tasksets with different charateristics
      case nums
      when "1"
         a = rand @param.short_num_task_range_1
         b = rand @param.mid_num_task_range_1
         c = rand @param.long_num_task_range_1
      when "2"
         a = rand @param.short_num_task_range_2
         b = rand @param.mid_num_task_range_2
         c = rand @param.long_num_task_range_2
      when "3"
         a = rand @param.short_num_task_range_3
         b = rand @param.mid_num_task_range_3
         c = rand @param.long_num_task_range_3
      when "4"
         a = rand @param.short_num_task_range_4
         b = rand @param.mid_num_task_range_4
         c = rand @param.long_num_task_range_4
      when "5"
         a = rand @param.short_num_task_range_5
         b = rand @param.mid_num_task_range_5
         c = rand @param.long_num_task_range_5
      when "6"
         a = rand @param.short_num_task_range_6
         b = rand @param.mid_num_task_range_6
         c = rand @param.long_num_task_range_6
      when "7"
         a = rand @param.short_num_task_range_7
         b = rand @param.mid_num_task_range_7
         c = rand @param.long_num_task_range_7
      else
         raise 'Error in numbering taskTypeNum'
      end
      return a, b, c
   end

   def generateSingleTask (size, mode, type)
      # Generates the task modality
      case type
      when "std"
         case mode
         when "implicit"
            case size
            when "short"
               p = rand @param.short_period_range
               e = rand @param.short_impl_exec_range
            when "mid"
               p = rand @param.mid_period_range
               e = rand @param.mid_impl_exec_range
            when "long"
               p = rand @param.long_period_range
               e = rand @param.long_impl_exec_range
            else
               raise 'Error size in generateSingleTask'
            end
            d = p
         when "arbitrary"
            case size
            when "short"
               p = rand @param.short_period_range
               e = rand @param.short_arbit_exec_range
               begin
                  d = rand @param.short_arbit_dead_range
               end while d <= p
            when "mid"
               p = rand @param.mid_period_range
               e = rand @param.mid_arbit_exec_range
               begin
                  d = rand @param.mid_arbit_dead_range
               end while d <= p
            when "long"
               p = rand @param.long_period_range
               e = rand @param.long_arbit_exec_range
               begin
                  d = rand @param.long_arbit_dead_range
               end while d <= p
            else
               raise 'Error size in generateSingleTask'
            end
         when "constrained"
            case size
            when "short"
               p = rand @param.short_period_range
               e = rand @param.short_constr_exec_range
               begin
                  d = rand @param.short_constr_dead_range
               end while d >= p
            when "mid"
               p = rand @param.mid_period_range
               e = rand @param.mid_constr_exec_range
               begin
                  d = rand @param.mid_constr_dead_range
               end while d >= p
            when "long"
               p = rand @param.long_period_range
               e = rand @param.long_constr_exec_range
               begin
                  d = rand @param.long_constr_dead_range
               end while d >= p
            else
               raise 'Error size in generateSingleTask'
            end
         else
            raise 'Error size in generateSingleTask'
         end

         t = BasicTask.new 0, 2 ** d, 2 ** p, 0, e

      when "mix"
         case mode
         when "implicit"
            case size
            when "short"
               p = rand @param.short_period_demo_mixed
               e = rand @param.short_impl_exec_range
            when "mid"
               p = rand @param.mid_period_demo_mixed
               e = rand @param.mid_impl_exec_range
            when "long"
               p = rand @param.long_period_demo_mixed
               e = rand @param.long_impl_exec_range
            else
               raise 'Error size in generateSingleTask'
            end
            d = p
         when "arbitrary"
            case size
            when "short"
               p = rand @param.short_period_demo_mixed
               e = rand @param.short_arbit_exec_range
               begin
                  d = rand @param.short_arbit_dead_demo_mixed
               end while d <= p
            when "mid"
               p = rand @param.mid_period_demo_mixed
               e = rand @param.mid_arbit_exec_range
               begin
                  d = rand @param.mid_arbit_dead_demo_mixed
               end while d <= p
            when "long"
               p = rand @param.long_period_demo_mixed
               e = rand @param.long_arbit_exec_range
               begin
                  d = rand @param.long_arbit_dead_demo_mixed
               end while d <= p
            else
               raise 'Error size in generateSingleTask'
            end
         when "constrained"
            case size
            when "short"
               p = rand @param.short_period_demo_mixed
               e = rand @param.short_constr_exec_range
               begin
                  d = rand @param.short_constr_dead_demo_mixed
               end while d >= p
            when "mid"
               p = rand @param.mid_period_demo_mixed
               e = rand @param.mid_constr_exec_range
               begin
                  d = rand @param.mid_constr_dead_demo_mixed
               end while d >= p
            when "long"
               p = rand @param.long_period_demo_mixed
               e = rand @param.long_constr_exec_range
               begin
                  d = rand @param.long_constr_dead_demo_mixed
               end while d >= p
            else
               raise 'Error size in generateSingleTask'
            end
         else
            raise 'Error size in generateSingleTask'
         end

         dead = expSolver (d)
         period = expSolver (p)
         t = BasicTask.new 0, dead, period, 0, e

      else
         raise 'Error size in generateSingleTask'
      end
      @taskset.push t
      # puts "Prio: #{t.prio}\t Dead: #{t.dead}\t Period: #{t.period}\t Exec: #{t.exec}"
   end

   def expSolver (code)
      code = code - 1
      a = Array.new
      a = @param.exponentsDemo.to_a.product([code])
      # puts a
      # puts "2 ^ #{a[code][0][0][0]} * 3 ^ #{a[code][0][0][1]} "\
      #      "5 ^ #{a[code][0][0][2]} * 7 ^ #{a[code][0][0][3]}"
      value = 2 ** a[code][0][0][0] *
              3 ** a[code][0][0][1] *
              5 ** a[code][0][0][2] *
              7 ** a[code][0][0][3]
      return value
   end

   def generateImplicitTaskset (short, mid, long, type)
      for i in 0..short
         generateSingleTask "short", "implicit", type
      end
      for i in 0..mid
         generateSingleTask "mid", "implicit", type
      end
      for i in 0..long
         generateSingleTask "long", "implicit", type
      end
   end

   def generateConstrainedTaskset (short, mid, long, type)
      for i in 0..short
         generateSingleTask "short", "constrained", type
      end
      for i in 0..mid
         generateSingleTask "mid", "constrained", type
      end
      for i in 0..long
         generateSingleTask "long", "constrained", type
      end
   end

   def generateArbitraryTaskset (short, mid, long, type)
      for i in 0..short
         generateSingleTask "short", "arbitrary", type
      end
      for i in 0..mid
         generateSingleTask "mid", "arbitrary", type
      end
      for i in 0..long
         generateSingleTask "long", "arbitrary", type
      end
   end

   def forcedTaskset
      t1 = BasicTask.new 0, 16, 2, 1, 1.8
      @taskset.push t1
      t2 = BasicTask.new 0, 17, 80, 2, 14.4
      @taskset.push t2
   end

   def forcedTaskset2
      t1 = BasicTask.new 0,  8000000,  8000000, 1, 3000000
      @taskset.push t1
      t2 = BasicTask.new 0, 12000000, 12000000, 2, 3000000
      @taskset.push t2
      t3 = BasicTask.new 0, 20000000, 20000000, 3, 5000000
      @taskset.push t3
   end

   def forcedTaskset3Unfeasible
      t1 = BasicTask.new 1, 4000000, 4000000, 1, 2000000
      t2 = BasicTask.new 2, 5000000, 5000000, 2, 2000000
      t3 = BasicTask.new 3, 7000000, 7000000, 3, 1000000
      t4 = BasicTask.new 4, 8000000, 8000000, 4, 1000000
      t5 = BasicTask.new 5, 9000000, 9000000, 5, 3000000
      @taskset.push t1
      @taskset.push t2
      @taskset.push t3
      @taskset.push t4
      @taskset.push t5
   end

   def setPriorityLevelsRateMonotonic
      i=1;
      @taskset.sort_by! {|t| t.period}.reverse!
      @taskset.each_cons(2).map do |t,n|
         t.prio = i
         if taskset.last == n then
            if t.period == n.period then
               n.prio = i
            else
               n.prio = i + 1
            end
         end
         if t.period == n.period then i else (i += 1) end
      end
   end

   def setPriorityLevelsDeadlineMonotonic
      i=1;
      @taskset.sort_by! {|t| t.dead}.reverse!
      @taskset.each_cons(2).map do |t,n|
         t.prio = i
         if @taskset.last == n then
            if t.dead == n.dead then
               n.prio = i
            else
               n.prio = i + 1
            end
         end
         if t.dead == n.dead then i else (i += 1) end
      end
   end

   def printDataFile
      # It generates the output file which will be the input for
      # the next procedure.
      i = 1;
      ofile = "../data_struct01.ads"
      File.open(ofile, 'w') do |out|
         out.puts "with Cyclic_Tasks; use Cyclic_Tasks;"
         out.puts ""
         out.puts "package Data_Struct01 is"

         # @taskset.each do |t|
         #    puts "Prio: #{t.prio}\t Dead: #{t.dead} => #{t.deadInMicroseconds}\t"\
         #         " Period: #{t.period} => #{t.periodInMicroseconds}\t Exec: "\
         #         "#{t.exec} => #{t.execInOperations}"
         # end

         @taskset.each do |t|
            str = "   C#{i} : Cyclic (#{t.prio}, #{t.deadInMicroseconds},"\
                  " #{t.periodInMicroseconds}, #{i}, #{t.execInOperations});"
            out.puts str
            i += 1;
         end
         out.puts "end Data_Struct01;"
         out.puts ""
      end
   end

   def printDataFile_withBlock
      # It generates the output file which will be the input for
      # the next procedure.
      i = 1;
      ofile = "../dfp_data_struct01.ads"
      File.open(ofile, 'w') do |out|
         out.puts "with DFP_Test_Procedure; use DFP_Test_Procedure;"
         out.puts ""
         out.puts "package DFP_Data_Struct01 is"

         # @taskset.each do |t|
         #    puts "Prio: #{t.prio}\t Dead: #{t.dead} => #{t.deadInMicroseconds}\t"\
         #         " Period: #{t.period} => #{t.periodInMicroseconds}\t Exec: "\
         #         "#{t.exec} => #{t.execInOperations}"
         # end
         @taskset.each do |t|
            if i == 1 or i == @taskset.length then
               str = "   C#{i} : Cyclic_Protection (#{t.prio}, #{t.deadInMicroseconds},"\
                     " #{t.periodInMicroseconds}, #{i}, #{t.execInOperations});"
               out.puts str
            else
               str = "   C#{i} : Cyclic (#{t.prio}, #{t.deadInMicroseconds},"\
                     " #{t.periodInMicroseconds}, #{i}, #{t.execInOperations});"
               out.puts str
            end
            i += 1;
         end
         out.puts "end DFP_Data_Struct01;"
         out.puts ""
      end
   end
end



#############
### DEBUG ###
#############

# gen = Generator.new
# gen.expSolver 10
# num_of_short, num_of_mid, num_of_long = gen.taskTypeNum "1"
# gen.generateImplicitTaskset num_of_short, num_of_mid, num_of_long, "mix"
# # puts "Implicit"
# # gen.generateArbitraryTaskset num_of_short, num_of_mid, num_of_long
# # puts "Arbitrary"
# # gen.generateConstrainedTaskset num_of_short, num_of_mid, num_of_long
# # puts "Constrained"
# gen.forcedTaskset3Unfeasible
# gen.Extact_MaxPrio_MinDead
# aaa, maxL = gen.computeRTAforEDF_withBlock
# puts "----- #{gen.taskset.length} -----"
# bbb = gen.computeRTAforFPS_withBlock
# puts "----- #{gen.taskset.length} -----"
# gen.printDataFile
# puts "EDF: #{aaa} - LOAD: #{maxL} - FPS: #{bbb}"
