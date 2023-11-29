achi="查看成就"
my_achi="已解锁"
lock_achi="未解锁"
config={
    msg={
        achievementmenu="╔════════════════════╗\n                   成就档案\n   —————————————\n              输入指令查看详细\n   —————————————\n   指令及效果：\n    「已解锁」 查看已解锁成就\n    「未解锁」 查看未解锁成就\n╚════════════════════╝\ntips:触发极低概率特殊事件可解锁相应成就"
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
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local player_achi=players[QQ]["Achievement"]
    local achi_namebuff={}
    local namebuff="已解锁成就："
    for i=1,#player_achi do
        local achi_id=player_achi[i]
        local name=achievements[achi_id]["name"]
        namebuff=namebuff.."\n".."      「"..name.."」\n".."            "
        local buffs=achievements[achi_id]["buff"]
        for key,val in pairs(buffs) do 
            local buff_name=" "
            if (key=="point") then
                buff_name="积分"
            elseif (key=="INT") then
                buff_name="智力"
            elseif (key=="CON") then
                buff_name="体质"
            elseif (key=="WIL") then
                buff_name="意志"
            elseif (key=="LUC") then
                buff_name="运气"
            elseif (key=="energy") then
                buff_name="精力"
            elseif (key=="mood") then
                buff_name="心情"
            elseif (key=="credit") then
                buff_name="学分"
            end 
            local sym=string.sub(val,1,1)
            local buff=" "
            if (sym=="-") then
                buff=buff_name..val
            else
                buff=buff_name.."+"..val
            end
            namebuff=namebuff..buff.."  "
        end
    end
    return namebuff
end

function viewLockAchievement(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local player_achi=players[QQ]["Achievement"]
    local player_achi_id={}
    local lock_num=0
    local lock_achievement_name="╔════════════════════╗\n                 推荐解锁成就\n   —————————————\n"
    for key,value in pairs(achievements) do
        local flag=1
        for i=1,#player_achi do
            if(key==player_achi[i]) then
                flag=0
                break
            end
        end
        if(flag==1)then
            lock_num=lock_num+1
            local achi_name=value["name"]
            lock_achievement_name=lock_achievement_name.."               "..achi_name.."\n"
            if (lock_num==10) then
                break
            end
        end
    end
    lock_achievement_name=lock_achievement_name.."╚════════════════════╝"
    if(lock_num==0) then
        return "所有成就均已解锁"
    end
    return lock_achievement_name
end