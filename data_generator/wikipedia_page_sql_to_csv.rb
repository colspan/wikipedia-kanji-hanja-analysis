#!/usr/bin/ruby -Ku

#(3,4,'대문','',10143,0,0,0.935387239731278,'20141006203547','20141006203549',12249295,11218,NULL)

f = open(ARGV[0])
f.each_line do |line|
  line.split('(').each do |record|
    values = record.sub('),','').gsub("'","").split(',')
    puts values[0] + "," + values[2] if values.length == 13
  end
end
f.close
