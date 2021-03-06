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

# Collection of methods related to the playlist.
module MPDPlaylist
  # Adds the specified file to the playlist.
  # Directories add recursively.
  def add(uri)
    send_request('add "%s"' % uri)
  end

  # Adds the specified file to the playlist and returns the song id.
  # An optional playlist position can be specified.
  def addid(uri, position = nil)
    command = 'addid "%s"' % uri
    command << ' %s' % position if position

    send_request(command).scan(/\d+/).first.to_i
  end

  # Clears the playlist.
  def clear
    send_request('clear')
  end

  # Deletes a song from the playlist.
  def delete(songpos)
    send_request('delete %s' % songpos)
  end

  # Deletes a song from the playlist.
  def deleteid(songid)
    send_request('deleteid %s' % songid)
  end

  # Returns an Array composed of Hashes containing information about the songs
  # in the playlist.
  def playlist
    split_and_hash(send_request('playlistinfo'))
  end

  # Swaps the positions of the given songs, specified by playlist positions.
  def swap(first, second)
    send_request('swap %s %s' % [first, second])
  end

  # Swaps the positions of the given songs, specified by song ids.
  def swapid(first, second)
    send_request('swapid %s %s' % [first, second])
  end
end
