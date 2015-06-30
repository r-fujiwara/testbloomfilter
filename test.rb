require 'bundler'
Bundler.require
require 'digest'

FILTER_SIZE = 150000

$bf = BloomFilter::Native.new(:size => FILTER_SIZE, hash: 13, :raise => false)

def gen_random_word(list, method, index)
  rand_word = Digest::SHA256.hexdigest(index.to_s)
  prev_length = list.length
  list << rand_word
  current_length = list.uniq.length
  if prev_length == current_length
    puts "********duplicate!...#{rand_word}***********"
    gen_random_word(list)
  else
    puts "#{method}...#{rand_word}"
    $bf.send method.to_sym, rand_word
  end
end

def set_random_unique_words(size, method)
  list = []
  size.times do |i|
    puts "index...#{i}"
    gen_random_word(list, method, i)
  end
end

set_random_unique_words FILTER_SIZE, 'insert'
set_random_unique_words FILTER_SIZE, 'include?'

bf.stats
