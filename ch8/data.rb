#!/usr/bin/env ruby

require 'redis'
require 'pry'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
$redis.flushall

count = 0
starting_time = Time.now

File.open(ARGV[0]).each do |line|
  count += 1
  next if count == 1
  date, data = line.split(',')
  $redis.set(date, data)
end

puts "#{count} days in time #{Time.now - starting_time}"
