create="crt"
setn="name"
male="m"
female="f"
setj="job"
random="rand"
free="free"
yes="y"
no="n"

msg_order={}
msg_order[create]="createPlayer"
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
        begin="{currentYear}年{currentMonth}月{currentDay}日             晴\n今天是进入大学的第一天,和其他普通的大学生一样,我对大学生活充满了好奇。我路过操场时不经意间瞥见几个身强力壮的学长,低头看着自己高中时被跑操捶打出来的健壮身躯,历经高考结束后的疯狂摸鱼而变得瘦弱,我开始担忧起自己的大学生活状态。此刻,“脆脆杀”和“超级大学人”的选择,摆在了我的面前。",
        intro="╔                                 ╗\n      脆脆杀的大学生活\n╚                                 ╝\n您好，我是大学的学生智能\nAI，现在请您配合我的工作，\n填写学生信息。",
        ask_name="请给我您的姓名「name+姓名」" ,
        ask_gender="请选择性别「m/f」" ,
        ask_job="请选择职业\n╔═══════════════╗\n            职业列表\n  ——————————\n   指令         职业\n 「job stu」  学生\n╚═══════════════╝\ntips:其他职业需通过成就\n         解锁",
        ask_quality="请选择随机分配或自主分配主属性,自主分配主属性请按智力、体质、意志、运气的顺序输入属性值（各属性值之和不大于48），以空格隔开,「rand/free+智力+体质+意志+运气」" ,
        quaility_info="智力:{int}  体质:{con}  意志:{wil}  运气:{luc}",
        ask_change="分配成功,是否更改上述信息「y/n」" , 
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

function begin()
    local currentTime = os.date("*t")
    local currentYear = currentTime.year
    config.msg.begin = config.msg.begin:gsub("{currentYear}", currentYear)
    local currentMonth = currentTime.month
    config.msg.begin = config.msg.begin:gsub("{currentTime}", currentTime)
    local currentDay = currentTime.day
    config.msg.begin = config.msg.begin:gsub("{currentDay}", currentDay)
    return config.msg.begin
end

function introduce()
    return config.msg.intro
end

function getName(msg)
    nickname = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#setn+1)
    return config.msg.ask_gender
end


function getGender(msg)
    if (msg.fromMsg == "m") then
        gender = "男"
    elseif (msg.fromMsg == "f") then
        gender = "女"
    end
    return config.msg.ask_job
end

function getJob(msg)
    local getjob = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#setj+1)
    if (getjob=="stu") then
        job="学生"
        return config.msg.ask_quality
    else
        job = nil
        return config.msg.error
    end
end

function printInfo(int,con,wil,luc)
    config.msg.quaility_info.int = int
    config.msg.quaility_info.con = con
    config.msg.quaility_info.wil = wil
    config.msg.quaility_info.luc = luc
    return config.msg.quaility_info
end


function randomQuality(msg)
    int=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    con=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    wil=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    luc=math.random(1, 6)+math.random(1, 6)+math.random(1, 6)
    sum=int+con+luc+wil
    printInfo(int,con,wil,luc)
    return config.msg.ask_change
end

function setQuality(msg)
    mainatt = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#setq+1)
    values = {}
    for val in mainatt:gmatch("%S+") do
        table.insert(values, val)
    end
    int=tonumber(values[1])
    con=tonumber(values[2])
    wil=tonumber(values[3])
    luc=tonumber(values[4])
    sum=int+con+luc+wil
    printInfo(int,con,wil,luc)
    return config.msg.ask_change
end
 
function askChange()
    return config.msg.ask_change
end

function getChange(msg)
    change=msg.fromMsg
    if (change == "y") then
        return config.msg.ask_name
    elseif (change == "n") then
        saveInfo()
    end
end

function saveInfo()
    local information = {
        [userQQ]={
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
                LUC = luc,
                SUM=sum
            },
            DailyAtt = {
                energy = 100,
                mood = 100
            },
            Event = {
                daily = {},
                weekly = {},
                spec = {}
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
                shop = 0
              },
              Mainline = {
                Semester = 1,
                credit = 0,
                rank = 0,
                FinishTimes = 0
              },
              Bag = {
                item = {},
                study = 0,
                sport = 0,
                snack = 0,
                game = 0,
                anima = 0,
                comp = 0,
                fans = 0,
                trophy = 0,
                sum = 0
              },
            Achievement = achievement,
            points = 0
        }
    }
    table.insert(players,information)
    data:set(players)
    return config.msg.success
end

function createPlayer(msg)
    local userQQ=msg.fromQQ
    nickname = nil
    gender = nil
    change = nil
    job = nil
    quaility = nil
    int=0
    con=0
    wil=0
    luc=0
    sum=0
    achievement = {}
    if (players[tostring(userQQ)]) then
        if (tonumber(players[tostring(userQQ)]["Mainline"]["FinishTimes"])>0) then
            achievement=players[tostring(userQQ)]["Achievement"]
            table.remove (players, userQQ)
        end
    end
    begin()
    introduce()
    return config.msg.ask_name
end