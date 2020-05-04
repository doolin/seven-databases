#!/usr/bin/env ruby
# frozen_string_literal: true

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
      $redis.set 'foo', 'bar'
      $redis.set 'count', 1
      $redis.incr 'baz'
      $redis.incr 'baz'
      $redis.incr 'count'
    end

    expect($redis.get('baz')).to eq '2'
    expect($redis.get('count')).to eq '2'
  end

  context 'hashes' do
    example 'hset' do
      # $redis.hset(user: 'eric', name: 'Eric Raymomd', password: 's3cr3t')
      $redis.hmset('user:eric', :name, 'Eric Raymomd', :password, 's3cr3t')
      expected = { user: 'eric', name: 'Eric Raymomd', password: 's3cr3t' }
      actual = $redis.hvals('user:eric')
      expected_vals = ['Eric Raymomd', 's3cr3t']
      expect(actual).to eq expected_vals
    end
  end

  context 'lists' do
    example 'rpush' do
      key = 'eric:wishlist'
      result = $redis.rpush(key, '7wks gog  prag')
      expect(result).to eq 1 # why eq 1?

      result = $redis.lrange(key, 0, -1)
      expect(result).to eq ['7wks gog  prag']

      # $ redis-cli
      # 127.0.0.1:6379> LRANGE eric:wishlist 0 -1
      # 1) "baz"
      # 2) "bar"
      # 3) "foo"
      # 4) "7wks gog  prag"
      # 127.0.0.1:6379>
      $redis.lpush(key, 'foo')
      $redis.lpush(key, 'bar')
      $redis.lpush(key, 'baz')
      result = $redis.lrange(key, 0, -1)
      expect(result).to eq ['baz', 'bar', 'foo', '7wks gog  prag']
    end
  end
end
