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

  def play songpos=false
    command = 'play'
    command << ' ' + songpos.to_s if songpos

    return send_request command
  end

  def pause pause
    return send_request 'pause ' + pause.to_s
  end

  def stop
    return send_request 'stop'
  end

  def next
    return send_request 'next'
  end

  def previous
    return send_request 'previous'
  end

  def seek songpos, time
    return send_request 'seek %s %s' % [songpos, time]
  end

  def add uri
    return send_request 'add "%s"' % uri
  end

  def delete songpos
    return send_request 'delete ' + songpos.to_s
  end

  def clear
    return send_request 'clear'
  end

  # Not yet complete.
  def playlistinfo
    playlist = send_request 'playlistinfo'
    playlist = playlist.split(/(?!\n)(?=file:)/).map do |song|
      generate_hash song
    end

    return playlist
  end
end
