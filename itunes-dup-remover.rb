#!/usr/bin/env ruby
###
# duplicates remover for iTunes
# ============================
# 
# # Dependencies
# 
# [RubyOSA]([http://rubyosa.rubyforge.org/)
# 
# # How to use
# 
# ## for lazy person:
# 
# 1. run this script "ruby itunes-dup-remover.rb" to display duplicated files
# 2. run with '-y' option to remove them
# 
# ## if your're not that lazy: (but this might be faster)
# 
# 1. create a playlist and give a unique name, "dupxxx", with in your playlists
# 2. get duplicates by 'File'->'Show Duplicates' on your library
# 3. add those "duplicates" into the playlist you created
# 4. run this script "ruby itunes-dup-remover.rb -p dupxxx" to display really duplicated files
# 5. run with '-y' option to remove them
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

def find_duplicates(playlist)
   tracks = {}
   playlist.file_tracks.each do |t|
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
   return tracks
end   

OPTS = {}

opt = OptionParser.new
opt.on('-y', '--yes') { OPTS[:y] = true }
opt.on('-p NAME', '--playlist-name NAME') { |v| OPTS[:p] = v }
opt.parse!(ARGV)

itunes = OSA.app('iTunes')
tracks = {}

if OPTS[:p]
   itunes.sources[0].user_playlists.each do |p|
      next if p.name != OPTS[:p]
      tracks = find_duplicates(p)
   end
else
   tracks = find_duplicates(itunes.sources[0].user_playlists[0])
end

tracks.each do |k,v|
   next if v.length < 2
   while v.length > 1 do
       track = v.pop
       puts track.location
       itunes.delete(track) if OPTS[:y]
   end
end
