cred="查看学分"
cred_rank="学分排行"
config={
    msg={
        cre_info="╔═══════════════╗\n            学分档案\n  ——————————\n  学分 {credit}      排行 {rank}\n  ——————————\n 「学分排行」  总排行\n╚═══════════════╝\ntips:学分可以通过上课、完成作业、考试提升",
        rank_info="╔                                 ╗\n            学分排行\n╚                                 ╝\n"
    }
}
msg_order={}
msg_order[cred]="viewPoint"
msg_order[cred_rank]="viewPointRank"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewPoint(msg)
    local QQ=tostring(msg.fromQQ)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local credit_list={}
    local QQ_list={}
    local name_list={}
    for k,v in pairs(players) do
        local credit=players[k]["Mainline"]["credit"]
        local name=players[k]["Info"]["Nickname"]
        table.insert(QQ_list,k)
        table.insert(credit_list,credit)
        table.insert(name_list,name)
    end
    local rank_list={}
    for i=1,#credit_list do
        local rank=1
        local credit1=credit_list[i]
        for j=1,#credit_list do
            local credit2=credit_list[j]
            if(credit2>credit1) then
                rank=rank+1
            end
        end
        table.insert(rank_list,rank)
    end
    for i=1,#QQ_list do
        local player_QQ=QQ_list[i]
        players[player_QQ]["Mainline"]["rank"]=rank_list[i]
    end
    data:set(players)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    local credit = players[QQ]["Mainline"]["credit"]
    local rank = players[QQ]["Mainline"]["rank"]
    config.msg.cre_info = config.msg.cre_info:gsub("{credit}", credit)
    config.msg.cre_info = config.msg.cre_info:gsub("{rank}", rank)
    return config.msg.cre_info
end

function viewPointRank(msg)
    local QQ=tostring(msg.fromQQ)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local credit_list={}
    local QQ_list={}
    local name_list={}
    for k,v in pairs(players) do
        local credit=players[k]["Mainline"]["credit"]
        local name=players[k]["Info"]["Nickname"]
        table.insert(QQ_list,k)
        table.insert(credit_list,credit)
        table.insert(name_list,name)
    end
    local rank_list={}
    for i=1,#credit_list do
        local rank=1
        local credit1=credit_list[i]
        for j=1,#credit_list do
            local credit2=credit_list[j]
            if(credit2>credit1) then
                rank=rank+1
            end
        end
        table.insert(rank_list,rank)
    end
    for i=1,#QQ_list do
        local player_QQ=QQ_list[i]
        players[player_QQ]["Mainline"]["rank"]=rank_list[i]
    end
    data:set(players)
    local total_rank=""
    local rank_num=20
    if(#QQ_list<rank_num) then
        rank_num=#QQ_list
    end
    for i=1,rank_num do
        for j=1,#QQ_list do
            local rank=rank_list[j]
            if(rank==i) then
                rank=string.format("%2d",rank)
                total_rank=total_rank.."\n"..rank.."    「"..name_list[j].."」        "..credit_list[j]
            end
        end
    end
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「crt」"
    end
    total_rank=total_rank.."\n······\n你的排行："..tostring(players[QQ]["Mainline"]["rank"])
    return config.msg.rank_info..total_rank
end