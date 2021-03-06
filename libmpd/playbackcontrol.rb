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

# Collection of methods related to playback control.
module MPDPlaybackControl
  # Plays the next song in the playlist.
  def next
    send_request('next')
  end

  # Sets pause state.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def pause(state = true)
    send_request('pause %s' % state.to_i)
  end

  # Returns +true+ if paused.
  # Otherwise, returns +false+.
  def paused?
    status[:state] == 'pause'
  end

  # Begins playing the playlist. If an argument is given, begins at the
  # specified song position.
  def play(songpos = nil)
    command = 'play'
    command << ' %s' % songpos if songpos

    send_request(command)
  end

  # Begins playing the playlist. If an argument is given, begins at the
  # specified song id.
  def playid(songid = nil)
    command = 'playid'
    command << ' %s' % songid if songid

    send_request(command)
  end

  # Returns +true+ if playing.
  # Otherwise, returns +false+.
  def playing?
    status[:state] == 'play'
  end

  # Plays the previous song in the playlist.
  def previous
    send_request('previous')
  end

  # Seeks to the given position of the current song.
  # Accepts an argument of seconds.
  def seek(time)
    send_request('seek %s %s' % [status[:song], time])
  end

  # Stops playing.
  def stop
    send_request('stop')
  end

  # Returns +true+ if stopped.
  # Otherwise, returns +false+.
  def stopped?
    status[:state] == 'stop'
  end
end
