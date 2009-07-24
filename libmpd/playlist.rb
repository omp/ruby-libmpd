#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

module MPDPlaylist
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

  # Returns an Array composed of Hashes containing information about the songs
  # in the playlist.
  #
  # Not yet complete.
  def playlistinfo
    return split_and_hash send_request 'playlistinfo'
  end
end
