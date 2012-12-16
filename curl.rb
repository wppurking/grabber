require 'open-uri'
threads = []
3.times do 
  threads << Thread.new do 
    puts open('http://localhost:3000/listing/us/B008YRG5JQ').read.length
  end
end

threads.each(&:join)
