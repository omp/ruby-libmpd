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

# Collection of methods related to the status.
module MPDStatus
  # Returns a Hash containing information about the current song.
  def currentsong
    return generate_hash(send_request('currentsong'))
  end

  # Returns a Hash containing the current status.
  def status
    return generate_hash(send_request('status'))
  end

  # Returns a Hash containing statistics.
  def stats
    return generate_hash(send_request('stats'))
  end
end
