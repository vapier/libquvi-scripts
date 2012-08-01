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

--
-- NOTE
--
-- academicearth.org hosts media at blip.tv or youtube.com .
-- Set "goto_url" to point to the actual location of the media.
--
-- The library will then relay the new URL to a media script that
-- accepts it.
--

local AcademicEarth = {} -- Utility functions specific to this script

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local r = {
    accepts = A.accepts(qargs.input_url,
                          {"academicearth%.org"}, {"/lectures/"}),
    categories = C.proto_http
  }
  return r
end

-- Parse media properties.
function parse(qargs)
  return AcademicEarth.to_media_url(qargs)
end

--
-- Utility functions
--

function AcademicEarth.get_redirect_url(self)
    local p = quvi.fetch(self.page_url)
    local s = p:match('ytID = "(.-)"')
    if s then
        self.redirect_url = 'http://youtube.com/e/' .. s
    else
        local s = p:match('embed src="(.-)"') -- blip
        if s then
            self.redirect_url = s
        else
            error('no match: blip or youtube pattern')
        end
    end
    return self
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
