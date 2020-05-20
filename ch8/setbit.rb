#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'
require 'redis'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
$redis.flushall

RSpec.describe self do
  context 'getbit and setbit' do
    example 'burgers' do
      key = 'my_burger'
      result = $redis.setbit(key, 1, 1)
      expect(result).to be 0

      result = $redis.getbit(key, 1)
      expect(result).to be 1

      result = $redis.getbit(key, 2)
      expect(result).to be 0
    end
  end
end

