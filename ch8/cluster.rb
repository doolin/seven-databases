#!/usr/bin/env ruby

require 'redis/distributed'
require 'pry'

SERVERS = [
  'redis://localhost:6379/',
  'redis://localhost:6380/'
]

# This API is not working.
# $redis = Redis::Distributed.new(SERVERS)
# $redis = Redis::Distributed.new

$redis.flushall
