require 'open-uri'
threads = []
100.times do
  threads << Thread.new do
    puts open('http://r.easya.cc:3000/listing/us/B008YRG5JQ').read.length
  end
end

threads.each(&:join)
