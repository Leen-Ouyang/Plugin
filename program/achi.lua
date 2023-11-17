achi="查看成就"
my_achi="已解锁"
lock_achi="未解锁"
config={
    msg={
        achievementmenu="╔════════════════════╗\n                   成就档案\n   —————————————\n              输入指令查看详细\n   —————————————\n   指令及效果：\n    「已解锁」 查看已解锁成就\n    「未解锁」 查看未解锁成就\n╚════════════════════╝\ntips:触发极低概率特殊事件可解锁相应成就",
        my_achievement="",
        lock_achievement=""
    }
}
msg_order={}
msg_order[achi]="viewAchievement"
msg_order[my_achi]="viewMyAchievement"
msg_order[lock_achi]="viewLockAchievement"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

achievement_information="achievement.json"
achi_data = getSelfData(achievement_information)
achievements = achi_data:get(nil, {})
if(achievements == nil)then
    achievements = {}
end

function viewAchievement(msg)
    return config.msg.achievementmenu
end

function viewMyAchievement(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local player_achi=players[QQ]["Achievement"]
    local achi_namebuff={}
    local namebuff="已解锁成就："
    for i=1,#player_achi do
        local achi_id=player_achi[i]
        local name=achievements[achi_id]["name"]
        namebuff=namebuff.."\n".."        "..name.."    "
        local buffs=achievements[achi_id]["buff"]
        for key,val in pairs(buffs) do
            local buff=key..":"..val
            namebuff=namebuff..buff.."  "
        end
    end
    return namebuff
end

function viewLockAchievement(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「创建新角色」"
    end
    return config.msg.lock_achievement
end