# frozen_string_literal: true
namespace :subscriptions do
  desc 'Migrates subscription flag status from candidates to users.'
  task :migrate, [:update] => [:environment] do |_task, args|
    if args.update
      puts 'update=true passed'
      puts 'starting in 5 seconds'
      sleep(1)
      puts 'starting in 4 seconds'
      sleep(1)
      puts 'starting in 3 seconds'
      sleep(1)
      puts 'starting in 2 seconds'
      sleep(1)
      puts 'starting in 1 seconds'
      sleep(1)

      changes = 0
      Candidate.find_each.with_index do |candidate, index|
        puts "#{index} - Candidate: #{candidate.id} starting"
        before_subscribed = candidate.user.subscribed
        after_subscribed = candidate.subscribed

        if before_subscribed != after_subscribed
          candidate.user.update(subscribed: after_subscribed)
          changes += 1
          puts "#{index} - Candidate: #{candidate.id} changed flag on user from #{before_subscribed} to #{after_subscribed}."
        end
      end

      puts "Made #{changes} changes to user subscription statuses"
    else
      puts 'update=false dry run'
      puts 'starting in 5 seconds'
      sleep(1)
      puts 'starting in 4 seconds'
      sleep(1)
      puts 'starting in 3 seconds'
      sleep(1)
      puts 'starting in 2 seconds'
      sleep(1)
      puts 'starting in 1 seconds'
      sleep(1)

      changes = 0
      Candidate.find_each.with_index do |candidate, index|
        puts "#{index} - Candidate: #{candidate.id} starting"
        before_subscribed = candidate.user.subscribed
        after_subscribed = candidate.subscribed

        if before_subscribed != after_subscribed
          puts "#{index} - Candidate: #{candidate.id} would change user subscribed from #{before_subscribed} to #{after_subscribed}."
          changes += 1
        end
      end

      puts "Would make #{changes} changes to user subscription statuses"
    end
  end
end
