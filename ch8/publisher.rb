#!/usr/bin/env ruby
# frozen_string_literal: true

require 'redis'
require 'rspec/autorun'
require 'pry'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
$redis.flushall

RSpec.describe self do
  let(:key) { 'comments' }

  describe 'publish' do
    example 'foo and bar' do
      # Not currently working
      # result = 0
      # expect {
      #   result = $redis.subscribe(key)
      # }.to change(result, 'changed')


      # These work with external client which is subscribed.
      result = $redis.publish(key, 'foo')
      expect(result).to eq 1

      $redis.publish(key, 'bar')
      expect(result).to eq 1
    end
  end
end


