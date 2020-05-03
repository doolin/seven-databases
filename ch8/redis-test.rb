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

  example 'multi' do
    $redis.multi do
      $redis.set "foo", "bar"
      $redis.set 'count', 1
      $redis.incr "baz"
      $redis.incr "baz"
      $redis.incr "count"
    end

    expect($redis.get('baz')).to eq '2'
    expect($redis.get('count')).to eq '2'
  end

  context 'hashes' do
    example 'hset' do
      # $redis.hset(user: 'eric', name: 'Eric Raymomd', password: 's3cr3t')
      $redis.hmset("user:eric", :name, 'Eric Raymomd', :password, "s3cr3t")
      expected = { user: 'eric', name: 'Eric Raymomd', password: 's3cr3t' }
      actual = $redis.hvals('user:eric')
      expected_vals = ["Eric Raymomd", "s3cr3t"]
      expect(actual).to eq expected_vals
    end
  end
end
