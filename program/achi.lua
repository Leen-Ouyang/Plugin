achi="achi"
config={
    msg={
        achievement="╔═══════════════╗\n            成就档案\n  ——————————\n      输入指令查看详细\n  ——————————\n   指令     效果\n 「mine」已解锁成就\n 「lock」未解锁成就\n╚═══════════════╝\ntips:触发极低概率特殊\n         事件可解锁相应成就"
    }
}
msg_order={}
msg_order[achi]="viewAchievement"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewAchievement(msg)
    return config.msg.achievement
end