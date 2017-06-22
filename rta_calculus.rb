#!/usr/bin/env ruby

class RTA_Calculus
   def computeRTAforFPS_withBlock
      # Method that compute the feasibility for a taskset under
      # FPS policy with Rate Monotonic method. It computes the same
      # taskset computed by the Baruah rule to test the exact feasibility.

      # setPriorityLevelsRateMonotonic
      setPriorityLevelsDeadlineMonotonic

      @taskset.sort_by! {|t| t.prio}.reverse!
      # @taskset.each do |t|
      #    puts "Prio: #{t.prio}\t Dead: #{t.dead}\t Period: #{t.period}\t Exec: #{t.exec}"
      # end
      i=1
      @taskset.each do |t|
         n = 0
         w = t.exec + t.FPS_InitCost + t.IPCP_BlockValue
         while true
            parts = 0
            @taskset.each do |tt|
               break if tt == t
               parts += (w / tt.period.to_f).ceil *
                        (tt.exec + tt.FPS_CS)
            end
            w_next = t.exec + parts
            # puts w_next
            if w_next == w then
               if w_next > t.period then
                  return false
               end
               break if true
            end
            if w_next > t.period then
               return false
            end
            w = w_next
            n += 1
         end
      end
      return true
   end

   def computeRTAforEDF_withBlock
      # Now it's time to apply the Baruah extended model to compute
      # the real elaboration load that system can sustain before
      # a crash.
      # We work with Implicit deadlines actually, so our

      maxLoad = 0.0
      dfpWorks = true
      # hyperPeriod = (@taskset.max_by &:period).period
      periodicArray = @taskset.map(&:period)
      hyperPeriod = periodicArray.reduce(:lcm)

      # @taskset.each do |t|
      #    puts "Prio: #{t.prio}\t Dead: #{t.dead}\t Period: #{t.period}\t Exec: #{t.exec}"
      # end

      # puts "hyperPeriod: " + hyperPeriod.to_s
      @taskset.sort_by! {|t| t.dead}

      @taskset.each do |taskForDead|
         maxH = 0.to_f
         @taskset.each do |task|
            comp = task.EDF_CS + task.exec # used in original computation
            # comp = task.exec # used for test in forcedTasksets
            val = [0, (((taskForDead.dead - task.dead) / task.period).floor) * comp + comp].max
            maxH = maxH + val
         end
         if taskForDead.dead < (maxH + taskForDead.DFP_BlockValue) then dfpWorks = false end
      end

      @taskset.each do |taskForDead|
         loopTimes = hyperPeriod / taskForDead.dead
         # puts "loopTimes: #{loopTimes}"
         for iter in 1..loopTimes do
            t = (iter * taskForDead.period) - taskForDead.dead
            if t == 0 then t = 1 end
            maxH = 0.to_f
            @taskset.each do |task|
               comp = task.EDF_CS + task.exec # used in original computation
               # comp = task.exec # used for test in forcedTasksets
               val = [0, (((t - task.dead) / task.period).floor) * comp + comp].max
               maxH = maxH + val
            end
            maxLoad = [maxLoad, (maxH / t)].max
            if maxLoad > 1 then return false, maxLoad end
         end
      end
      if dfpWorks
         return true, maxLoad
      else
         return false, maxLoad
      end
   end

   def computeRTAforFPS
      # Method that compute the feasibility for a taskset under
      # FPS policy with Rate Monotonic method. It computes the same
      # taskset computed by the Baruah rule to test the exact feasibility.

      # setPriorityLevelsRateMonotonic
      setPriorityLevelsDeadlineMonotonic

      @taskset.sort_by! {|t| t.prio}.reverse!
      # @taskset.each do |t|
      #    puts "Prio: #{t.prio}\t Dead: #{t.dead}\t Period: #{t.period}\t Exec: #{t.exec}"
      # end
      i=1
      @taskset.each do |t|
         n = 0
         w = t.exec + t.FPS_CS1
         while true
            parts = 0
            @taskset.each do |tt|
               break if tt == t
               parts += (w / tt.period.to_f).ceil *
                     (tt.exec + tt.FPS_CS1 + tt.FPS_CS2)
                  #   (tt.exec + tt.FPS_CS)
            end
            w_next = t.exec + parts
            # puts w_next
            if w_next == w then
               if w_next > t.period then
                  return false
               end
               break if true
            end
            if w_next > t.period then
               return false
            end
            w = w_next
            n += 1
         end
      end
      return true
   end

   def computeRTAforEDF
      # Now it's time to apply the Baruah extended model to compute
      # the real elaboration load that system can sustain before
      # a crash.
      # We work with Implicit deadlines actually, so our

      maxLoad = 0.0
      # hyperPeriod = (@taskset.max_by &:period).period
      periodicArray = @taskset.map(&:period)
      hyperPeriod = periodicArray.reduce(:lcm)

      # @taskset.each do |t|
      #    puts "Prio: #{t.prio}\t Dead: #{t.dead}\t Period: #{t.period}\t Exec: #{t.exec}"
      # end

      # puts "hyperPeriod: " + hyperPeriod.to_s
      @taskset.sort_by! {|t| t.dead}
      @taskset.each do |taskForDead|
         loopTimes = hyperPeriod / taskForDead.dead
   puts "loopTimes: #{loopTimes}\n"
         for iter in 1..loopTimes do
            t = (iter * taskForDead.period) - taskForDead.dead
            if t == 0 then t = 1 end
            maxH = 0.to_f
            @taskset.each do |task|
               # comp = task.EDF_CS + task.exec # used in original computation
               comp = task.EDF_CS1 + task.exec + task.EDF_CS2 # used in original computation
               # comp = task.exec # used for test in forcedTasksets
               val = [0, (((t - task.dead) / task.period).floor) * comp + comp].max
               maxH = maxH + val
            end
            maxLoad = [maxLoad, (maxH / t)].max
            # print t.to_s + ": " + maxLoad.to_s + "\r"
            if maxLoad > 1 then return false, maxLoad end
         end
      end
      return true, maxLoad
   end

   def Extact_MaxPrio_MinDead
      return @taskset.max_by(&:prio).prio, @taskset.min_by(&:dead).dead
   end
end
