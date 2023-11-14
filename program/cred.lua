cred="cred"
ocnfig={
    msg={
        point_info="╔═══════════════╗\n            学分档案\n  ——————————\n  学分 {credit}      排行 {rank}\n  ——————————\n 「ttl」  总排行\n╚═══════════════╝\ntips:学分可以通过考试\n          提升"
    }
}
msg_order={}
msg_order[cred]="cred"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewPoint(msg){
    local QQ=tostring(msg.fromQQ)
    local credit = players[QQ]["Mainline"]["credit"]
    local rank = players[QQ]["Mainline"]["rank"]
    cnfig.msg.point_info = config.msg.record:gsub("{credit}", credit)
    cnfig.msg.point_info = config.msg.record:gsub("{rank}", rank)
    return config.msg.point_info
}