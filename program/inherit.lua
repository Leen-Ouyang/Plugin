inhkey="查看继承码"

msg_order={}
msg_order[inhkey]="viewKey"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewKey(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local key = players[QQ]["Inheritkey"]
    return "继承码："..key
end