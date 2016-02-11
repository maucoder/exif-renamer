#!/usr/bin/env ruby

require 'rubygems'
require 'mime/types'
require 'exifr'
require 'pp'

def getDateTimefromEXIF(filename)
	date = EXIFR::JPEG::new(filename).date_time_original.to_s()
	date.gsub!(/[\ |:]/, '-')
	return date
end

def isJPEGFile(filename)
	MIME::Types.type_for(filename).each {|mime|
		if (mime == 'image/jpeg') then
			return true
		end
	}
	return false
end

def renameJPEG(filename)
	if (not isJPEGFile(filename))
		puts "#{filename} is not valid jpeg file"
		return -1
	end

	date = getDateTimefromEXIF(filename)
	if (date.empty?) then
		puts "#{filename} doesn't have date information in exif."
		return -1
	end
	new_filename = "#{date}-#{filename}"
	
	File.rename(filename, new_filename)
end

def printUsage()
	puts "Usage: exif-renamer.rb <*.jpg> ..."
end

def main()
	if (ARGV.size() == 0) then
		printUsage()
		exit -1
	end

	files = ARGV
	files.each {|file| renameJPEG(file)}
end

if __FILE__ == $0
	main()
end
