config = {
    msg = {
        begin="{currentYear}年{currentMonth}月{currentDay}日   {currentWeekday}    晴\n今天是进入大学的第一天,和其他普通的大学生一样,我对大学生活充满了好奇。我路过操场时不经意间瞥见几个身强力壮的学长,低头看着自己高中时被跑操捶打出来的健壮身躯,历经高考结束后的疯狂摸鱼而变得瘦弱,我开始担忧起自己的大学生活状态。此刻,“脆脆杀”和“超级大学人”的选择,摆在了我的面前。",
        intro="╔                                 ╗\n      脆脆杀的大学生活\n╚                                 ╝\n您好，我是大学的学生智能\nAI，现在请您配合我的工作，\n填写学生信息。",
        ask_name="请给我您的姓名" ,
        ask_gender="请选择性别「m/f」" ,
        ask_job="请选择职业\n╔═══════════════╗\n            职业列表\n  ——————————\n   指令     职业\n 「stu」  学生\n╚═══════════════╝\ntips:其他职业需通过成就\n         解锁",
        ask_quality="请选择随机分配或自主分配主属性「rand/free」" ,
        set_quality="请按智力、体质、意志、运气的顺序输入属性值（各属性值之和不大于48），以空格隔开",
        quaility_info="智力:{int}  体质:{con}  意志:{wil}  运气:{luc}",
        ask_change="分配成功,是否更改上述信息「y/n」" , 
        change_info="请选择要修改的信息\n╔═══════════════╗\n            信息列表\n  ——————————\n   指令     信息\n 「name」 名称\n 「gdr」  性别\n 「job」  职业\n 「att」  属性\n╚═══════════════╝",
        success="信息填入成功！输入「help」查看更多指令",
        error="输入错误，请重新输入"       
    }
}

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

--createPlayer(event)

function createPlayer(event)
    local userQQ = event.sender.id
    -- 如果该用户qq号没有创建过角色，就创建角色
    if (players[tostring(userQQ)] == nil) then
        local currentTime = os.time()
        local currentYear = os.date("%Y", currentTime)
        config.msg.begin = config.msg.begin:gsub("{currentYear}", currentYear)
        local currentMonth = os.date("%m", currentTime)
        config.msg.begin = config.msg.begin:gsub("{currentTime}", currentTime)
        local currentDay = os.date("%d", currentTime)
        config.msg.begin = config.msg.begin:gsub("{currentDay}", currentDay)
        local currentWeekday = os.date("%A", currentTime)
        config.msg.begin = config.msg.begin:gsub("{currentWeekday}", currentWeekday)

        begin()
        introduce()

        askName()
        getName(msg)

        askGender()
        gender = nil
        while gender==nil do
            getGender(msg)
        end

        askJob()
        job = nil
        while job==nil do
            getJob(msg)
        end

        askQuality()
        quaility = nil
        while quaility==nil do
            getQuality(msg)
        end
        if (quaility=="rand") then
            randomQuality()
        elseif(quaility=="free") then
            setQuality(msg)
        end

        askChange()
        change=nil
        while change ~=n do
            getChange(msg)
            if (change == "y") then
                changeinfo=nil
                while changeinfo==nil do
                    getchange(msg)
                end
            end
        end
        succeed()
    end
end

function begin()
    return config.msg.begin
end

function introduce()
    return config.msg.intro
end

function askName()
    return config.msg.ask_name
end

function getName(msg)
    nickname=msg.fromMsg
    QQ=msg.fromQQ
end

function askGender()
    return config.msg.ask_gender
end

function getGender(msg)
    if (msg.fromMsg == "m") then
        gender = "男"
    elseif (msg.fromMsg == "f") then
        gender = "女"
    else
        gender = nil
        return config.msg.error
    end
end

function askJob()
    return config.msg.ask_job
end

function getJob(msg)
    if (msg.fromMsg=="stu") then
        job="学生"
    else
        job = nil
        return config.msg.error
    end
end

function askQuality()
    return config.msg.ask_quality
end

function getQuality(msg)
    if (msg.fromMsg == "rand") then
        quaility = "rand"
    elseif (msg.fromMsg == "free") then
        quaility = "free"
        return config.msg.set_quality
    else
        quaility = nil
        return config.msg.error
    end
end

function randomQuality()
    int=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    con=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    wil=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    luc=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    config.msg.quaility_info.int = int
    config.msg.quaility_info.con = con
    config.msg.quaility_info.wil = wil
    config.msg.quaility_info.luc = luc
    return config.msg.quaility_info
end

function setQuality(msg)
    mainatt=msg.fromMsg
    values = {}
    for val in mainatt:gmatch("%S+") do
        table.insert(values, val)
    end
    int=values[1]
    con=values[2]
    wil=values[3]
    luc=values[4]
    config.msg.quaility_info.int = int
    config.msg.quaility_info.con = con
    config.msg.quaility_info.wil = wil
    config.msg.quaility_info.luc = luc
    return config.msg.quaility_info
end

function askChange()
    return config.msg.ask_change
end

function getChange(msg)
    change=msg.fromMsg
    if (change == "y") then
        return config.msg.change_info
    elseif (change ~= "n") then
        change=nil
        return config.msg.error
    end
end

function getchange(msg)
    changeinfo=msg.fromMsg
    if (msg.fromMsg == "name") then
        askName()
        getName(msg)
    elseif (msg.fromMsg == "gdr") then
        askGender()
        gender = nil
        while gender==nil do
            getGender(msg)
        end
    elseif (msg.fromMsg == "job") then
        askJob()
        job = nil
        while job==nil do
            getJob(msg)
        end
    elseif (msg.fromMsg == "att") then
        askQuality()
        quaility = nil
        while quaility==nil do
            getQuality(msg)
        end
        if (quaility=="rand") then
            randomQuality()
        elseif(quaility=="free") then
            setQuality(msg)
        end
    else
        changeinfo=nil
        return config.msg.error
    end
end

function saveInfo()
    local information = {
        [QQ]={
            Info = {
                Nickname = nickname,
                Introduction = "",
                Gender = gender,
                Job = job
            },
            MainAtt = {
                INT = int,
                CON = con,
                WIL = wil,
                LUC = luc
            },
            DailyAtt = {
                energy = 100,
                mood = 100
            },
            Mainline = {
                Semester = 1,
                credit = 0
            },
            Bag = {},
            Achievement = {},
            points = 0
        }
    }
    table.insert(players,information)
    data:set(players)
end

function succeed()
    return config.msg.success
end