flash_dailyAtt_order = "刷新每日状态"
modify_Semester_order = "修改游戏阶段"
modify_credit_order = "修改学分"
Sem_order = "修改阶段"
Cre_order = "修改学分"
player_information="player.json"

config = {
    msg = {
        lack_privileges = "你没有权力这么做",
        finish_flash = "已刷新每日状态",
        finish_modify_Semester = "已更改游戏阶段",
        finish_modify_credit = "已修改学分",
        ask_Semester = "请以格式“修改阶段+游戏阶段”输入你想要到达的游戏阶段\n",
        ask_credit = "请以格式“修改学分+想要得到的学分”输入你想要到达的学分\n",
    }
}

msg_order = {}
msg_order[flash_dailyAtt_order] = "flash_dailyAtt"
msg_order[modify_Semester_order] = "modify_Semester"
msg_order[modify_credit_order] = "modify_credit"
msg_order[Sem_order] = "Sem"
msg_order[Cre_order] = "Cre"

data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function Sem(msg)
    local QQ = msg.fromQQ
    if getUserConf(msg.fromQQ,"trust")<4 then
        return lack_privileges
    end
    value = tonumber(msg.fromMsg)
    players[QQ]["Mainline"]["Semester"]=value
    data:set(players)
    return finish_modify_Semester
end

function Cre(msg)
    local QQ = msg.fromQQ
    if getUserConf(msg.fromQQ,"trust")<4 then
        return lack_privileges
    end
    value = tonumber(msg.fromMsg)
    players[QQ]["Mainline"]["credit"]=value
    data:set(players)
    return finish_modify_credit
end

function flash_dailyAtt(msg)
    
    local QQ = msg.fromQQ
    if getUserConf(msg.fromQQ,"trust")<4 then
        return lack_privileges
    end
    players[QQ]["DailyAtt"]["energy"]=100
    players[QQ]["DailyAtt"]["mood"]=100
    data:set(players)
    return finish_flash;
end


function modify_Semester(msg)
    local QQ = msg.fromQQ
    if getUserConf(msg.fromQQ,"trust")<4 then
        return lack_privileges
    end
    return ask_Semester
    
end

function modify_credit(msg)
    local QQ = msg.fromQQ
    if getUserConf(msg.fromQQ,"trust")<4 then
        return lack_privileges
    end
    return ask_credit
end
