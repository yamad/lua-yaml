require "yaml"

local doc = yaml.load[[
%YAML 1.1
---
map: Wrapped
     line

map2:
  seq:
  - libyaml     # C Fast YAML 1.1
  - lua-yaml    # Lua binding to libyaml
...
]]

assert(doc.map == "Wrapped line",       'map value should be "Wrapped line"')
assert(doc.map2.seq[1] == "libyaml",    'seq[1] value should be "libyaml"')
assert(#doc.map2.seq == 2,              'length of seq should be 2')

print "All tests passed"
