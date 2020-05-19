#!/usr/bin/env ruby

# ./bloomfilter.rb ../data/us-weather-history/KJAX.csv

LIMIT = 10_000

require 'bloomfilter-rb'

bloomfilter = BloomFilter::Redis.new size: 1_000_000

$redis = Redis.new host: '127.0.0.1', port: 6379
$redis.flushall

count = 0
start = Time.now

File.open(ARGV[0]).each do |line|
  count += 1
  next if count == 1

  date, mean = line.split(',', 3)
  bloomfilter.insert(date)
end

puts "Contains 2014-7-1? #{bloomfilter.include?('2014-7-1')}"
puts "Contains 2010-7-1? #{bloomfilter.include?('2010-7-1')}"
