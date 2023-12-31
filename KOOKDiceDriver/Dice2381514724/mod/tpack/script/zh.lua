spaceKiller = function(str)
    return string.gsub(str, "[%s]+", "")
end
local json = require("json")
local para = {}
para["text"] = spaceKiller(string.sub(msg.fromMsg, #"？" + 1))
local _, data = http.post("https://lab.magiconch.com/api/nbnhhsh/guess", json.encode(para))
local str = ""
if spaceKiller(string.sub(msg.fromMsg, #"？" + 1)) and #data ~= 2 then
    local trans = json.decode(data)[1].trans
    if trans then
        for i = 1, #trans do
            str = str .. trans[i] .. " "
        end
    else
        return
    end
    return para["text"] .. ": " .. str
else
    return
end