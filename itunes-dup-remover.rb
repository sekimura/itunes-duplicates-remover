#!/usr/bin/env ruby
###
# duplicates remover for iTunes
#
# Depencies:
#   rubyosa http://rubyosa.rubyforge.org/
#
# How to use:
#
# 1. create a playlist and name it 'dup'
# 2. display duplicates by 'File' -> 'Show Duplicates' on your library
# 3. add all tracks, displaying as duplicated, into the 'dup' playlist
# 4. run this script "ruby itunes-duplicates-remover.rb". It will display files locations
# 5. run with '-y' option to remove them
# 
###

require 'rubygems'
require 'rbosa'
require 'digest/md5'
require 'optparse'

## http://d.hatena.ne.jp/kusakari/20080129/1201596766
class Numeric
  def roundoff(d=0)
    x = 10**d
    if self < 0
      (self * x - 0.5).ceil.quo(x)
    else
      (self * x + 0.5).floor.quo(x)
    end
  end
end

OPTS = {}

opt = OptionParser.new
opt.on('-y', '--yes') { OPTS[:y] = true }
opt.on('-n VAL', '--playlist-name VAL') { |v| OPTS[:n] = v }
opt.parse!(ARGV)

itunes = OSA.app('iTunes')

tracks = {}
playlist_name = OPTS[:n] || 'dup'

itunes.sources.each do |s|
   s.user_playlists.each do |p|
      next unless p.name == playlist_name
      p.file_tracks.each do |t|
         digest = Digest::MD5.hexdigest( [ t.name.downcase, 
                                           t.album.downcase, 
                                           t.artist.downcase,
                                           t.duration.roundoff.to_s,
                                           t.track_number,
                                         ].join(':') )
         if tracks[digest]
            tracks[digest] << t
         else
            tracks[digest] = [t]
         end
      end
   end
end

tracks.each do |k,v|
   next if v.length < 2
   while v.length > 1 do
       track = v.pop
       puts track.location
       itunes.delete(track) if OPTS[:y]
   end
end
