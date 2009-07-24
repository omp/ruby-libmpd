#!/usr/bin/env ruby
#
# Copyright 2009 David Vazgenovich Shakaryan <dvshakaryan@gmail.com>
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.

module MPDDatabase
  # Finds all songs in the database where _field_ is _value_.
  # Matching is case-sensitive.
  #
  # Possible field names: album, artist, title.
  def find field, value
    return split_and_hash send_request 'find %s "%s"' % [field, value]
  end

  # Finds all songs in the database where _field_ contains _value_.
  # Matching is not case-sensitive.
  #
  # Possible field names: album, artist, filename, title.
  def search field, value
    return split_and_hash send_request 'search %s "%s"' % [field, value]
  end

  # Updates the database.
  # If an argument is given, update that particular file or directory.
  def update uri=nil
    command = 'update'
    command << ' "%s"' % uri if uri

    return send_request command
  end
end
