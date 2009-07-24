#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

module MPDPlaybackOptions
  # Sets consume state.
  # When consume is activated, each song played is removed from the playlist.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def consume state=true
    return send_request 'consume %s' % state.to_i
  end

  # Sets crossfading between songs.
  def crossfade seconds
    return send_request 'crossfade ' + seconds.to_s
  end

  # Sets random state.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def random state=true
    return send_request 'random %s' % state.to_i
  end

  # Sets repeat state.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def repeat state=true
    return send_request 'repeat %s' % state.to_i
  end

  # Sets volume from a range of 0-100.
  def setvol volume
    return send_request 'setvol ' + volume.to_s
  end

  # Sets single state.
  # When single is activated, playback is stopped after the current song. If
  # repeat is also activated, the current song is repeated.
  #
  # Accepts an argument of _true_ to enable or _false_ to disable.
  # If no argument is given, defaults to _true_.
  def single state=true
    return send_request 'single %s' % state.to_i
  end

  # Returns +true+ if consume is activated.
  # Otherwise, returns +false+.
  def consume?
    return true if status[:consume] == '1'
    return false
  end

  # Returns +true+ if random is activated.
  # Otherwise, returns +false+.
  def random?
    return true if status[:random] == '1'
    return false
  end

  # Returns +true+ if repeat is activated.
  # Otherwise, returns +false+.
  def repeat?
    return true if status[:repeat] == '1'
    return false
  end

  # Returns +true+ if single is activated.
  # Otherwise, returns +false+.
  def single?
    return true if status[:single] == '1'
    return false
  end
end