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

# Collection of methods related to playback options.
module MPDPlaybackOptions
  # Sets consume state.
  # When consume is activated, each song played is removed from the playlist.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def consume(state = true)
    send_request('consume %s' % state.to_i)
  end

  # Returns +true+ if consume is activated.
  # Otherwise, returns +false+.
  def consume?
    status[:consume] == '1'
  end

  # Sets crossfading between songs.
  def crossfade(seconds)
    send_request('crossfade %s' % seconds)
  end

  # Returns the current crossfade setting as an integer.
  def crossfade?
    status[:xfade].to_i
  end

  # Sets random state.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def random(state = true)
    send_request('random %s' % state.to_i)
  end

  # Returns +true+ if random is activated.
  # Otherwise, returns +false+.
  def random?
    status[:random] == '1'
  end

  # Sets repeat state.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def repeat(state = true)
    send_request('repeat %s' % state.to_i)
  end

  # Returns +true+ if repeat is activated.
  # Otherwise, returns +false+.
  def repeat?
    status[:repeat] == '1'
  end

  # Sets volume from a range of 0 to 100.
  def volume(volume)
    send_request('setvol %s' % volume)
  end

  # Returns the current volume as an integer.
  def volume?
    status[:volume].to_i
  end

  # Sets single state.
  # When single is activated, playback is stopped after the current song. If
  # repeat is also activated, the current song is repeated.
  #
  # Accepts an argument of +true+ to enable or +false+ to disable.
  # If no argument is given, defaults to +true+.
  def single(state = true)
    send_request('single %s' % state.to_i)
  end

  # Returns +true+ if single is activated.
  # Otherwise, returns +false+.
  def single?
    status[:single] == '1'
  end
end
