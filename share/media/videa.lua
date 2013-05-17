-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2011  Bastien Nocera <hadess@hadess.net>
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

local Videa = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  Videa.normalize(qargs)
  return {
    can_parse_url = Videa.can_parse_url(qargs),
    domains = table.concat({'videa.hu'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "videa"
    Videa.normalize(self)

    local p = quvi.fetch(self.page_url)

    self.id = p:match("v=(%w+)")
                or error("no match: media id")

    self.title = p:match('"og:title"%s+content="(.-)"')
                    or error("no match: media title")

    local s  = p:match("%?f=(.-)&") or error("no match: f param")
    self.url = {'http://videa.hu/static/video/' .. s:gsub("%.%d+$","")}

    self.thumbnail_url = p:match('"og:image"%s+content="(.-)"') or ''

    return self
end

--
-- Utility functions
--

function Videa.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('^videa%.hu$')
       and t.path   and t.path:lower():match('^/videok/.+/.+%-%w+$')
  then
    return true
  else
    return false
  end
end

function Videa.normalize(self) -- "Normalize" an embedded URL
    local id = self.page_url:match('/flvplayer%.swf%?v=(.-)$')
    if not id then return end

    self.page_url = 'http://videa.hu/videok/' .. id
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
