#!/usr/bin/ruby -Ku

i=0
f = open(ARGV[0])
f.each_line do |line|
  line.split('(').each do |record|
    values = record.sub('),','').split(',')
    if values[1] == "'ko'" then
      id = values[0].gsub("'","").to_i
      string = values[2].gsub("'","")
      puts id.to_s + "," + string
    end
  end
end
f.close
