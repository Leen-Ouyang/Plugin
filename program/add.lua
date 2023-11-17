add="新内容"
msg_order={}
msg_order[add]="viewNew"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

semester_information="Semester.json"
sem_data = getSelfData(semester_information)
semesters = sem_data:get(nil, {})
if(semesters == nil)then
    semesters = {}
end

function viewNew(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local sem=players[QQ]["Mainline"]["Semester"]
    local new_content=semesters[sem]["description"]
    return new_content
end