#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

require 'socket'

class TrueClass # :nodoc:
  def to_i
    return 1
  end
end

class FalseClass # :nodoc:
  def to_i
    return 0
  end
end

class MPD
  # Initialise an MPD object with the specified host and port.
  #
  # The default host is "localhost" and the default port is 6600.
  def initialize host='localhost', port=6600
    @host = host
    @port = port
  end

  # Connect to the server.
  def connect
    # Connect to MPD and return response.
    @socket = TCPSocket.new @host, @port
    return @socket.gets.chomp
  end

  def send_request command
    # Escape backslashes in command.
    @socket.puts command.gsub('\\', '\\\\\\')
    return get_response
  end

  def get_response
    response = String.new

    while true
      line = @socket.gets

      return response if line == "OK\n"
      return false if line =~ /^ACK/

      response << line
    end
  end

  def generate_hash str
    hash = Hash.new

    str.split("\n").each do |line|
      field, value = line.split(': ')
      hash[field.downcase.to_sym] = value
    end

    return hash
  end

  # Returns a Hash containing information about the current song.
  def currentsong
    return generate_hash send_request 'currentsong'
  end

  # Returns a Hash containing the current status.
  def status
    return generate_hash send_request 'status'
  end

  # Returns a Hash containing statistics.
  def stats
    return generate_hash send_request 'stats'
  end

  # Begins playing the playlist. If argument is supplied, begin at specified
  # song position.
  def play songpos=false
    command = 'play'
    command << ' ' + songpos.to_s if songpos

    return send_request command
  end

  # Begins playing the playlist. If argument is supplied, begin at specified
  # song id.
  def playid songid=false
    command = 'playid'
    command << ' ' + songid.to_s if songid

    return send_request command
  end

  # Sets pause state.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def pause state=true
    return send_request 'pause %s' % state.to_i
  end

  # Stops playing.
  def stop
    return send_request 'stop'
  end

  # Plays next song in the playlist.
  def next
    return send_request 'next'
  end

  # Plays previous song in the playlist.
  def previous
    return send_request 'previous'
  end

  # Seeks to the given position of the given song.
  def seek songpos, time
    return send_request 'seek %s %s' % [songpos, time]
  end

  # Seeks to the given position of the given song id.
  def seekid songid, time
    return send_request 'seekid %s %s' % [songid, time]
  end

  # Adds the specified file to the playlist. (Directories add recursively.)
  def add uri
    return send_request 'add "%s"' % uri
  end

  # Deletes a song from the playlist.
  def delete songpos
    return send_request 'delete ' + songpos.to_s
  end

  # Clears the playlist.
  def clear
    return send_request 'clear'
  end

  def split_and_hash str
    songs = str.split(/(?!\n)(?=file:)/).map do |song|
      generate_hash song
    end

    return songs
  end

  # Returns an Array composed of Hashes containing information about the songs
  # in the playlist.
  #
  # Not yet complete.
  def playlistinfo
    return split_and_hash send_request 'playlistinfo'
  end

  # Find all songs in database with an exact match.
  def find type, what
    return split_and_hash send_request 'find %s "%s"' % [type, what]
  end

  # Searches the database.
  def search type, what
    return split_and_hash send_request 'search %s "%s"' % [type, what]
  end

  # Sets consume state.
  # When consume is activated, each song played is removed from the playlist.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def consume state=true
    return send_request 'consume %s' % state.to_i
  end

  # Sets crossfading between songs.
  def crossfade seconds
    return send_request 'crossfade ' + seconds.to_s
  end

  # Sets random state.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def random state=true
    return send_request 'random %s' % state.to_i
  end

  # Sets repeat state.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def repeat state=true
    return send_request 'repeat %s' % state.to_i
  end

  # Sets volume from a range of 0-100.
  def setvol volume
    return send_request 'setvol ' + volume.to_s
  end

  # Sets single state.
  # When single is activated, playback is stopped after the current song. If
  # repeat is also activated, the current song is repeated.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def single state=true
    return send_request 'single %s' % state.to_i
  end

  # Returns +true+ if playing.
  # Otherwise, returns +false+.
  def playing?
    return true if status[:state] == 'play'
    return false
  end

  # Returns +true+ if paused.
  # Otherwise, returns +false+.
  def paused?
    return true if status[:state] == 'pause'
    return false
  end

  # Returns +true+ if stopped.
  # Otherwise, returns +false+.
  def stopped?
    return true if status[:state] == 'stop'
    return false
  end

  # Returns +true+ if consume is activated.
  # Otherwise, returns +false+.
  def consume?
    return true if status[:consume] == '1'
    return false
  end

  # Returns +true+ if random is activated.
  # Otherwise, returns +false+.
  def random?
    return true if status[:random] == '1'
    return false
  end

  # Returns +true+ if repeat is activated.
  # Otherwise, returns +false+.
  def repeat?
    return true if status[:repeat] == '1'
    return false
  end

  # Returns +true+ if single is activated.
  # Otherwise, returns +false+.
  def single?
    return true if status[:single] == '1'
    return false
  end

  private :generate_hash
  private :get_response
  private :split_and_hash
end
