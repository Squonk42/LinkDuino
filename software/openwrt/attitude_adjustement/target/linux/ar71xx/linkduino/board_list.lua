#!/usr/bin/lua
uci = require("luci.model.uci")
state = uci.cursor_state()
state:set_confdir("/usr/share/arduino/hardware/arduino/")
state:load("arduino")
state:foreach("arduino", "boards",
              function(section)
                 local ids = section.id
                 local names = section.name
                 print("#ids=" .. #ids .. ", #names=" .. #names)
                 for i = 1, #ids do
                    print("id=" .. ids[i] .. ", name=" .. names[i])
                 end
              end
             )
state:unload("arduino")
