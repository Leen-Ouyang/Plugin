pnt="查看积分"
config={
    msg={
        point_info="╔══════════════════╗\n            积分档案\n  ————————————\n    积分   {point}\n  ————————————\n  获取方法：积分获取路径执行\n  事件、获取成就、签到等(不\n  要试图py管理员，我也不保证\n  会发生什么)\n╚══════════════════╝\ntips:电动车，不上牌保安把你拦下来"
    }
}
msg_order={}
msg_order[pnt]="viewPoint"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewPoint(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local point = players[QQ]["points"]
    local rank = players[QQ]["Mainline"]["rank"]
    config.msg.point_info = config.msg.point_info:gsub("{point}", point)
    config.msg.point_info = config.msg.point_info:gsub("{rank}", rank)
    return config.msg.point_info
end