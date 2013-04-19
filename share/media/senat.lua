-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2012  Raphaël Droz <raphael.droz+floss@gmail.com>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This program is free software: you can redistribute it and/or
-- modify it under the terms of the GNU Affero General Public
-- License as published by the Free Software Foundation, either
-- version 3 of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General
-- Public License along with this program.  If not, see
-- <http://www.gnu.org/licenses/>.
--

local Senat = {} -- Utility functions unique to this script.

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = Senat.can_parse_url(qargs),
    domains = table.concat({'videos.senat.fr'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "senat"

    self.id = self.page_url:match(".-/video(%d+)%.html")
                or error("no match: media ID")

    local p = quvi.fetch(self.page_url)

    self.title = p:match('<title>(.-)</title>')
                  or error("no match: media title")

    self.thumbnail_url = p:match('image=(.-)&') or ''

    self.url = {p:match('name="flashvars" value=".-file=(.-flv)')
                  or error("no match: media stream URL") }

    return self
end

--
-- Utility functions.
--

function Senat.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  local p = '^/%w+/videos/%d+/video%d+%.html$'
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('^videos%.senat%.fr$')
       and t.path   and t.path:lower():match(p)
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
