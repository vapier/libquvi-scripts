-- libquvi-scripts
-- Copyright (C) 2010-2012  Toni Gundogdu <legatvs@gmail.com>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301  USA
--

local Break = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Break.can_parse_url(qargs),
    domains = table.concat({'break.com'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  local p = quvi.fetch(qargs.input_url)

  qargs.thumb_url = p:match('"og:image" content="(.-)"') or ''
  qargs.title = p:match('id="vid_title" content="(.-)"') or ''
  qargs.id = p:match("ContentID='(.-)'") or ''

  local n = p:match("FileName='(.-)'") or error("no match: file name")
  local h = p:match('flashVars.icon = "(.-)"') or error("no match: file hash")

  qargs.streams = Break.iter_streams(n, h)

  return qargs
end

--
-- Utility functions.
--

function Break.can_parse_url(qargs)
  local U = require 'quvi/url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('break%.com$')
       and t.path   and t.path:lower():match('^/index/')
  then
    return true
  else
    return false
  end
end

function Break.iter_streams(n, h)
  local u = string.format("%s.flv?%s", n, h)
  local S = require 'quvi/stream'
  return {S.stream_new(u)}
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
