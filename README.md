duplicates remover for iTunes
============================

# Dependencies

[RubyOSA]([http://rubyosa.rubyforge.org/)

# How to use

## for lazy person:

1. run this script "ruby itunes-dup-remover.rb" to display duplicated files
2. run with '-y' option to remove them

## if your're not that lazy: (but this might be faster)

1. create a playlist and give a unique name, "dupxxx", with in your playlists
2. get duplicates by 'File'->'Show Duplicates' on your library
3. add those "duplicates" into the playlist you created
4. run this script "ruby itunes-dup-remover.rb -p dupxxx" to display really duplicated files
5. run with '-y' option to remove them
