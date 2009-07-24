#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

require 'socket'
require 'libmpd/playbackcontrol'
require 'libmpd/playbackoptions'
require 'libmpd/playlist'
require 'libmpd/status'

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
  include MPDPlaybackControl
  include MPDPlaybackOptions
  include MPDPlaylist
  include MPDStatus

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

  private :generate_hash
  private :get_response
  private :split_and_hash
end
