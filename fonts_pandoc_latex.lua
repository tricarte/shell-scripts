#!/usr/bin/env texlua
-- https://github.com/jgm/pandoc/wiki/Trials-and-Tribulations%3A-How-to-find-correct-font-names-for-Pandoc%27s-use-with-LuaLaTeX%3F
-- First run luaotfload-tool -u -vvv

kpse.set_program_name("fonts.sh")

cachefile  = kpse.expand_var("$TEXMFVAR")  .. "/luatex-cache/generic/names/luaotfload-names.luc"
fontlist = dofile(cachefile)
assert(fontlist,"Could not load font name database")

local tmp = {}

for _,font in ipairs(fontlist.mappings) do
  tmp[#tmp + 1] = font.fontname
end
table.sort(tmp)

for _,fontname in ipairs(tmp) do
  print(fontname)
end
