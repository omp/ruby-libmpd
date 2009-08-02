#!/usr/bin/env ruby
#
#--
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.
#++
#
# *Author*:: David Vazgenovich Shakaryan
# *License*:: GNU General Public License v3


require 'socket'

MODULE_PATH = File.expand_path(File.dirname(__FILE__)) + '/libmpd/'
require MODULE_PATH + 'database'
require MODULE_PATH + 'playbackcontrol'
require MODULE_PATH + 'playbackoptions'
require MODULE_PATH + 'playlist'
require MODULE_PATH + 'status'

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

# Class for connecting and communicating with the daemon.
class MPD
  include MPDDatabase
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

  # Connects to the server.
  def connect
    @socket = TCPSocket.new @host, @port
    return @socket.gets.chomp
  end

  # Sends a command to the server and returns the response.
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

  private :generate_hash
  private :get_response
  private :split_and_hash
end
