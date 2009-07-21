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
end
