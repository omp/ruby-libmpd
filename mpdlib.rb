#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

require 'socket'

class MPD
  def initialize host='localhost', port=6600
    @host = host
    @port = port
  end

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

      break if line == "OK\n"
      return false if line =~ /^ACK/

      response << line
    end

    return true if response.empty?
    return response
  end

  def generate_hash str
    hash = Hash.new

    str.split("\n").each do |line|
      field, value = line.split(': ')
      hash[field] = value
    end

    return hash
  end

  def currentsong
    return generate_hash send_request 'currentsong'
  end

  def status
    return generate_hash send_request 'status'
  end

  def stats
    return generate_hash send_request 'stats'
  end

  def next
    return send_request 'next'
  end

  def previous
    return send_request 'previous'
  end
end
