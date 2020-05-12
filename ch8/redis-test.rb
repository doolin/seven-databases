#!/usr/bin/env ruby
# frozen_string_literal: true

require 'redis'
require 'rspec/autorun'
require 'pry'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
$redis.flushall
# $redis.set 'foo', 'bar'

RSpec.describe self do
  describe 'set/get' do
    example 'set a key' do
      key = 'foo'
      value = 'bar'
      $redis.set key, value
      expected = $redis.get(key)
      expect(expected).to eq value
    end
  end

  example 'mset/mget' do
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
      # expected = { user: 'eric', name: 'Eric Raymomd', password: 's3cr3t' }
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

  context 'stack' do
    context 'from the left' do
      describe 'lpop' do
        example 'pops from the left' do
          key = 'strange:loop'
          $redis.lpush(key, 'foo')
          $redis.lpush(key, 'bar')
          $redis.lpush(key, 'baz')
          expect($redis.lpop(key)).to eq 'baz'
          expect($redis.lpop(key)).to eq 'bar'
          expect($redis.lpop(key)).to eq 'foo'
          expect($redis.lpop(key)).to be nil
        end
      end
    end
  end

  context 'blocking lists p. 268' do
    $pub = Redis.new(host: '127.0.0.1', port: 6379)
    $pub.flushall
    $sub = Redis.new(host: '127.0.0.1', port: 6379)
    $sub.flushall

    # This isn't working, and I'm not sure quite how to get it to work
    # other than forking a process.
    xexample 'pop a commemt' do
      # t = Thread.new do
      expect($sub.brpop('comments', 5)).to eq('foo')
      # end
      $pub.lpush('comments', 'prag is great')
      Thread.kill(t)
    end
  end

  context 'sets' do
    before { $redis.flushall }

    describe 'sadd and smember' do
      example 'add three elements to a set' do
        $redis.flushall
        vals = %w[nytimes pragprog wapo]
        result = $redis.sadd('news', vals)
        expect(result).to be 3

        actual = $redis.smembers('news')
        expect(actual).to contain_exactly(*vals)
      end
    end

    describe 'sinter, sdiff, sunion, sunionstore' do
      example 'add two elements to a set' do
        news_vals = %w[nytimes prag]
        news = 'news'
        result = $redis.sadd(news, news_vals) # vals.join(' '))
        # expect(result).to be true
        expect(result).to be 2

        tech = 'tech'
        tech_vals = %w[wired prag]
        result = $redis.sadd(tech, tech_vals) # vals.join(' '))
        expect(result).to be 2

        sinter = $redis.sinter(news, tech)
        expect(sinter).to eq ['prag']

        sdiff = $redis.sdiff(news, tech)
        expect(sdiff).to eq ['nytimes']

        sdiff = $redis.sdiff(tech, news)
        expect(sdiff).to eq ['wired']

        work = %w[wired nytimes prag]
        sunion = $redis.sunion(news, tech)
        # expect(sunion).to eq ['prag', 'wired', 'nytimes'] # works on home mac
        expect(sunion).to eq work # works on work mac

        sunion = $redis.sunion(tech, news)
        # expect(sunion).to eq ['prag', 'wired', 'nytimes']
        expect(sunion).to eq work # works on work mac

        result = $redis.sunionstore('websites', news, tech)
        # expect($redis.smembers('websites')).to eq ["prag", "wired", "nytimes"]
        expect($redis.smembers('websites')).to eq work
      end
    end

    context 'sorted sets' do
      # https://www.rubydoc.info/gems/redis/Redis#zadd-instance_method
      describe 'zadd' do
        example 'count visits' do
          result = $redis.zadd('visits', 500, 'wks') # 9 gog 9999 pragprog')
          expect(result).to be true

          result = $redis.zadd('visits', [[9, 'gog'], [9999, 'prag']])
          expect(result).to be 2

          result = $redis.zincrby('visits', 1, 'prag')
          expect(result).to eq 10_000.0
        end
      end
    end

    context 'ranges' do
      describe 'zrange' do
        example 'extract first 2' do
          $redis.flushall

          result = $redis.zadd('visits', 500, 'wks') # 9 gog 9999 pragprog')
          expect(result).to be true

          result = $redis.zadd('visits', [[9, 'gog'], [9999, 'prag']])
          expect(result).to be 2

          result = $redis.zrange('visits', 0, 1)
          expect(result).to eq %w[gog wks]

          result = $redis.zrevrange('visits', 0, -1, with_scores: true)
          expected = [['prag', 9999.0], ['wks', 500.0], ['gog', 9.0]]
          expect(result).to eq expected

          result = $redis.zrangebyscore('visits', 9, 10_001)
          expect(result).to eq %w[gog wks prag]
        end
      end
    end
  end

  context 'unions' do
    describe 'zunionstore' do
      example 'from book p. 271' do
        result = $redis.zadd('votes', [[2, 'wks'], [0, 'gog'], [9001, 'prag']])
        expect(result).to be 3
      end
    end
  end
end
