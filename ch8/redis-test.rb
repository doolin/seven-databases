#!/usr/bin/env ruby

require 'redis'
require 'rspec/autorun'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
$redis.flushall
# $redis.set 'foo', 'bar'

RSpec.describe self do
  example 'set a key' do
    key = 'foo'
    value = 'bar'
    $redis.set key, value
    expected = $redis.get(key)
    expect(expected).to eq value
  end

  example 'mset / mget' do
    k1 = 'gog'
    v1 = 'google'
    k2 = 'yah'
    v2 = 'yahoo'
    $redis.mset(k1, v1, k2, v2)
    expected = $redis.mget(k1, k2)
    expect(expected).to eq [v1, v2]
  end
end
