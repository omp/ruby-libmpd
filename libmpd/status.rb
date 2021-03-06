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

# Collection of methods related to the status.
module MPDStatus
  # Clears the error message in the status, if one exists.
  def clearerror
    send_request('clearerror')
  end

  # Returns information about the current song.
  def current
    generate_hash(send_request('currentsong'))
  end

  # Returns daemon and database statistics.
  def stats
    generate_hash(send_request('stats'))
  end

  # Returns the status.
  def status
    generate_hash(send_request('status'))
  end
end
