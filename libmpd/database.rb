#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

module MPDDatabase
  # Find all songs in database with an exact match.
  def find type, what
    return split_and_hash send_request 'find %s "%s"' % [type, what]
  end

  # Searches the database.
  def search type, what
    return split_and_hash send_request 'search %s "%s"' % [type, what]
  end
end
