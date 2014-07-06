#!/usr/bin/env ruby
#
#--
# Copyright 2009-2014 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.
#++
#
# *Author*:: David Vazgenovich Shakaryan
# *License*:: GNU General Public License v3

require 'socket'

require_relative 'libmpd/database'
require_relative 'libmpd/playbackcontrol'
require_relative 'libmpd/playbackoptions'
require_relative 'libmpd/playlist'
require_relative 'libmpd/status'

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

  # Exception class used for MPD-related errors. At the moment, it is only
  # raised when attempting to perform an operation without having connected
  # first.
  class Error < StandardError
  end

  attr_accessor :host, :port

  # Initialise an MPD object with the specified host and port.
  #
  # The default host is "localhost" and the default port is 6600.
  def initialize(host = 'localhost', port = 6600)
    @host = host
    @port = port
  end

  # Connects to the server.
  def connect
    @socket = TCPSocket.new(@host, @port)

    @socket.gets.chomp
  end

  # Disconnects from the server.
  def disconnect
    ensure_connected

    @socket.close
    @socket = nil
  end

  # Sends a command to the server and returns the response.
  def send_request(command)
    ensure_connected

    # Escape backslashes in command.
    @socket.puts command.gsub('\\', '\\\\\\')

    get_response
  end

  private

  def ensure_connected
    raise MPD::Error, 'Not connected to server.' if @socket.nil?
  end

  def get_response
    response = String.new

    loop do
      line = @socket.gets

      return response if line == "OK\n"
      return false if line =~ /^ACK/

      response << line
    end
  end

  def generate_hash(str)
    hash = Hash.new

    str.split("\n").each do |line|
      field, value = line.split(': ', 2)
      hash[field.downcase.intern] = value
    end

    hash
  end

  def split_and_hash(str)
    str.split(/(?!\n)(?=file:)/).map do |song|
      generate_hash(song)
    end
  end
end
