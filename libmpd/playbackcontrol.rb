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

# Collection of methods related to playback control.
module MPDPlaybackControl
  # Plays the next song in the playlist.
  def next
    return send_request('next')
  end

  # Sets pause state.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def pause(state=true)
    return send_request('pause %s' % state.to_i)
  end

  # Returns +true+ if paused.
  # Otherwise, returns +false+.
  def paused?
    return true if status[:state] == 'pause'
    return false
  end

  # Begins playing the playlist. If an argument is given, begins at the
  # specified song position.
  def play(songpos=false)
    command = 'play'
    command << ' %s' % songpos if songpos

    return send_request(command)
  end

  # Begins playing the playlist. If an argument is given, begins at the
  # specified song id.
  def playid(songid=false)
    command = 'playid'
    command << ' %s' % songid if songid

    return send_request(command)
  end

  # Returns +true+ if playing.
  # Otherwise, returns +false+.
  def playing?
    return true if status[:state] == 'play'
    return false
  end

  # Plays the previous song in the playlist.
  def previous
    return send_request('previous')
  end

  # Seeks to the given position of the given song.
  def seek(songpos, time)
    return send_request('seek %s %s' % [songpos, time])
  end

  # Seeks to the given position of the given song id.
  def seekid(songid, time)
    return send_request('seekid %s %s' % [songid, time])
  end

  # Stops playing.
  def stop
    return send_request('stop')
  end

  # Returns +true+ if stopped.
  # Otherwise, returns +false+.
  def stopped?
    return true if status[:state] == 'stop'
    return false
  end
end
