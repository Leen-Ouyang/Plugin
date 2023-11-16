cred="查看学分"
config={
    msg={
        point_info="╔═══════════════╗\n            学分档案\n  ——————————\n  学分 {credit}      排行 {rank}\n  ——————————\n 「学分排行」  总排行\n╚═══════════════╝\ntips:学分可以通过上课、完成作业、考试提升"
    }
}
msg_order={}
msg_order[cred]="viewPoint"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewPoint(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「crt」"
    end
    local credit = players[QQ]["Mainline"]["credit"]
    local rank = players[QQ]["Mainline"]["rank"]
    config.msg.point_info = config.msg.record:gsub("{credit}", credit)
    config.msg.point_info = config.msg.record:gsub("{rank}", rank)
    return config.msg.point_info
end