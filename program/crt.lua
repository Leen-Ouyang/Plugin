create="创建新角色"
inheritplayer="继承角色"
inheritkey="继承码"
newplayer="新角色"
setn="姓名"
male="男"
female="女"
setj="职业"
random="随机"
free="分配"
yes="是"
no="否"

msg_order={}
msg_order[create]="createPlayer"
msg_order[inheritplayer]="askKey"
msg_order[inheritkey]="getKey"
msg_order[newplayer]="askName"
msg_order[setn]="getName"
msg_order[male]="getGender"
msg_order[female]="getGender"
msg_order[setj]="getJob"
msg_order[random]="randomQuality"
msg_order[free]="setQuality"
msg_order[yes]="getChange"
msg_order[no]="getChange"

config = {
    msg = {
        begin="{currentYear}年{currentMonth}月{currentDay}日             晴\n    今天是进入大学的第一天,和其他普通的大学生一样,我对大学生活充满了好奇。我路过操场时不经意间瞥见几个身强力壮的学长,低头看着自己高中时被跑操捶打出来的健壮身躯,历经高考结束后的疯狂摸鱼而变得瘦弱,我开始担忧起自己的大学生活状态。此刻,“脆脆杀”和“超级大学人”的选择,摆在了我的面前。",
        intro="╔                                 ╗\n      脆脆杀的大学生活\n╚                                 ╝\n您好，我是大学的学生智能AI，现在请您配合我的工作，填写学生信息。",
        ask_inherit="请问是否继承角色「继承角色/新角色」",
        ask_key="请输入继承码「继承码+16位继承码」",
        ask_name="请给我您的姓名「姓名+玩家姓名」" ,
        ask_gender="请选择性别「男/女」" ,
        ask_job="请选择职业\n╔═══════════════╗\n            职业列表\n  ——————————\n   指令         职业\n 「职业 学生」  学生\n╚═══════════════╝\ntips:其他职业需通过成就解锁",
        ask_quality="请选择随机分配或自主分配主属性,自主分配主属性请按智力、体质、意志、运气的顺序输入属性值（各属性值之和不大于48），以空格隔开,「随机/分配+智力值+体质值+意志值+运气值」" ,
        quaility_info="智力:{int}  体质:{con}  意志:{wil}  运气:{luc}",
        ask_change="分配成功,是否确认保存上述信息「是/否」" , 
        inherit_successs="继承角色成功！\n输入「帮助」查看更多指令",
        inherit_fail="继承码错误，请重新输入",
        success="信息填入成功！\n输入「帮助」查看更多指令\n恭喜！解锁成就「种子发芽」",
        error="输入错误，请重新输入"       
    }
}

temp="temp.json"
temp_data = getSelfData(temp)
temps = temp_data:get(nil,{})
if(temps == nil)then
    temps = {}
end

function askKey(msg)
    return config.msg.ask_key
end

function getKey(msg)
    local userQQ=msg.fromQQ
    local key = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#inheritkey+1)
    local flag = 0
    local inheritQQ=""
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end

    for k,v in pairs(players) do
        if (key==v["Inheritkey"]) then
            flag=1
            inheritQQ=k
            break
        end
    end
    if (flag==0) then
        return config.msg.inherit_successs
    else
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[userQQ]=players[inheritQQ]
        data:set(players)
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[inheritQQ]=nil
        data:set(players)
        temp="temp.json"
        temp_data = getSelfData(temp)
        temps = temp_data:get(nil,{})
        if(temps == nil)then
            temps = {}
        end
        temps[userQQ]=temps[inheritQQ]
        temp_data:set(temps)
        temp="temp.json"
        temp_data = getSelfData(temp)
        temps = temp_data:get(nil,{})
        if(temps == nil)then
            temps = {}
        end
        temps[inheritQQ]=nil
        temp_data:set(temps)
        return config.msg.inherit_successs
    end
end

function askName(msg)
    return config.msg.ask_name
end

function getName(msg)
    local userQQ=msg.fromQQ
    nickname = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#setn+1)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    players[userQQ]["Info"]["Nickname"]=nickname
    data:set(players)
    return config.msg.ask_gender
end


function getGender(msg)
    local userQQ=msg.fromQQ
    gender = msg.fromMsg
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    players[userQQ]["Info"]["Gender"]=gender
    data:set(players)
    return config.msg.ask_job
end

function getJob(msg)
    local userQQ=msg.fromQQ
    local getjob = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#setj+1)
    if (getjob=="学生") then
        job="学生"
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[userQQ]["Info"]["Job"]=job
        data:set(players)
        return config.msg.ask_quality
    else
        job = nil
        return config.msg.error
    end
end

function randomQuality(msg)
    local userQQ=msg.fromQQ
    int=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    con=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    wil=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    luc=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    sum=int+con+luc+wil
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    players[userQQ]["MainAtt"]["INT"]=int
    players[userQQ]["MainAtt"]["CON"]=con
    players[userQQ]["MainAtt"]["WIL"]=wil
    players[userQQ]["MainAtt"]["LUC"]=luc
    players[userQQ]["MainAtt"]["SUM"]=sum
    players[userQQ]["DailyAtt"]["energy"]=players[userQQ]["DailyAtt"]["energy"]+con
    players[userQQ]["DailyAtt"]["mood"]=players[userQQ]["DailyAtt"]["mood"]+wil
    players[userQQ]["DailyAtt"]["energy_limit"]=players[userQQ]["DailyAtt"]["energy"]
    players[userQQ]["DailyAtt"]["mood_limit"]=players[userQQ]["DailyAtt"]["mood"]
    data:set(players)
    config.msg.quaility_info = config.msg.quaility_info:gsub("{int}", int)
    config.msg.quaility_info = config.msg.quaility_info:gsub("{con}", con)
    config.msg.quaility_info = config.msg.quaility_info:gsub("{wil}", wil)
    config.msg.quaility_info = config.msg.quaility_info:gsub("{luc}", luc)
    return config.msg.quaility_info.."\n"..config.msg.ask_change
end

function setQuality(msg)
    local userQQ=msg.fromQQ
    local mainatt = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#free+1)
    local values = {}
    for val in mainatt:gmatch("%S+") do
        table.insert(values, val)
    end
    int=tonumber(values[1])
    con=tonumber(values[2])
    wil=tonumber(values[3])
    luc=tonumber(values[4])
    sum=int+con+luc+wil
    if (sum>48) then
        return "属性值之和超过48，请重新输入「分配+智力值+体质值+意志值+运气值」或选择随机分配「随机」"
    else
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[userQQ]["MainAtt"]["INT"]=int
        players[userQQ]["MainAtt"]["CON"]=con
        players[userQQ]["MainAtt"]["WIL"]=wil
        players[userQQ]["MainAtt"]["LUC"]=luc
        players[userQQ]["MainAtt"]["SUM"]=sum
        players[userQQ]["DailyAtt"]["energy"]=players[userQQ]["DailyAtt"]["energy"]+con
        players[userQQ]["DailyAtt"]["mood"]=players[userQQ]["DailyAtt"]["mood"]+wil
        players[userQQ]["DailyAtt"]["energy_limit"]=players[userQQ]["DailyAtt"]["energy"]
        players[userQQ]["DailyAtt"]["mood_limit"]=players[userQQ]["DailyAtt"]["mood"]
        data:set(players)
        config.msg.quaility_info = config.msg.quaility_info:gsub("{int}", int)
        config.msg.quaility_info = config.msg.quaility_info:gsub("{con}", con)
        config.msg.quaility_info = config.msg.quaility_info:gsub("{wil}", wil)
        config.msg.quaility_info = config.msg.quaility_info:gsub("{luc}", luc)
        return config.msg.quaility_info.."\n"..config.msg.ask_change
    end
end

function getChange(msg)
    change=msg.fromMsg
    local userQQ=msg.fromQQ
    if (change == "否") then
        return config.msg.ask_name
    elseif (change == "是") then
        local user_temp={
            last_sign = {},  
            daily_done = {},  
            weekly_done = {},  
            next_daily = {  
                generate_time = "nil",  
                num = "nil",  
                type = "nil"  
            },  
            next_weekly = {  
                generate_time = "nil",  
                num = "nil",  
                type = "nil"  
            },
            discount = {
                snack = 1,
                study = 1,
                sport = 1,
                game = 1,
                anima = 1,
                comp = 1,
                fans = 1,
                trophy = 1,
                other = 1
            },
            odds={},
            buff = {}
        }
        temps[userQQ]=user_temp
        temp_data:set(temps)
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        achievement=players[userQQ]["Achievement"]
        table.insert(achievement,"ac000")
        local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local key = ""
        local flag=1
        while flag==1 do
            flag=0
            key=""
            for i = 1, 16 do
                local rand = math.random(1, #charset)
                local randchar = string.sub(charset, rand, rand)
                key = key..randchar
            end
            for k,v in pairs(players) do
                if (key==v["Inheritkey"]) then
                    flag=1
                end
            end
        end
        players[userQQ]["Achievement"]=achievement
        players[userQQ]["points"]=20
        players[userQQ]["Inheritkey"]=key
        data:set(players)
        return config.msg.success
    end
end

function createPlayer(msg)
    local userQQ=msg.fromQQ
    nickname = nil
    gender = nil
    change = nil
    job = nil
    int=0
    con=0
    wil=0
    luc=0
    sum=0
    achievement = {}
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    local player_num=0
    for k,v in pairs(players) do
        local rank=v["Mainline"]["rank"]
        if(rank>0) then
            player_num=player_num+1
        end
    end
    if (players[tostring(userQQ)]) then
        if (tonumber(players[tostring(userQQ)]["Mainline"]["FinishTimes"])>0) then
            achievement=players[tostring(userQQ)]["Achievement"]
        end
    end
    local information = {
        Info = {
            Nickname = "",
            Introduction = " ",
            Gender = "",
            Job = ""
        },
        MainAtt = {
            INT = 0,
            CON = 0,
            WIL = 0,
            LUC = 0,
            SUM=0
        },
        DailyAtt = {
            energy_limit = 100,
            mood_limit = 100,
            energy = 100,
            mood = 100
        },
        Event = {
            Daily = {},
            Weekly = {},
            Spec = {}
            },
            Count = {
            daily = 0,
            weekly = 0,
            spec = 0,
            exam = 0,
            sign = 0,
            board = 0,
            bottleSend = 0,
            bottleRecv = 0,
            bottleCast = 0,
            public = 0,
            disturb = 0,
            shop = 0,
            FailtoSleepCounter = 0,
            MeetJasonCounter = 0,
            PoiliticsCounter = 0,
            petting_dog = 0,
            petting_cat = 0,
            AnimaCounter = 0
            },
            Mainline = {
            Semester = 1,
            credit = 0,
            rank = 0,
            FinishTimes = 0
            },
            Bag = {
            },
        Achievement = {},
        points = 0,
        Inheritkey = ""
    }
    players[userQQ]=information
    players[userQQ]["Achievement"]=achievement
    players[userQQ]["Mainline"]["rank"]=player_num
    data:set(players)
    local currentTime = os.date("*t")
    local currentYear = currentTime.year
    config.msg.begin = config.msg.begin:gsub("{currentYear}", currentYear)
    local currentMonth = currentTime.month
    config.msg.begin = config.msg.begin:gsub("{currentMonth}", currentMonth)
    local currentDay = currentTime.day
    config.msg.begin = config.msg.begin:gsub("{currentDay}", currentDay)
    return config.msg.begin.."\n\n"..config.msg.intro.."\n"..config.msg.ask_inherit
end