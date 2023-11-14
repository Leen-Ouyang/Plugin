pnt="pnt"
ocnfig={
    msg={
        point_info="╔═══════════════╗\n            积分档案\n  ——————————\n  积分 {point}\n  ——————————\n 「way」  积分获取路径\n╚═══════════════╝\ntips:电动车，不上牌\n          保安把你拦下来"
    }
}
msg_order={}
msg_order[pnt]="pnt"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewPoint(msg)
    local QQ=tostring(msg.fromQQ)
    local point = players[QQ]["points"]
    local rank = players[QQ]["Mainline"]["rank"]
    connfig.msg.point_info = config.msg.record:gsub("{point}", point)
    config.msg.point_info = config.msg.record:gsub("{rank}", rank)
    return config.msg.point_info
end