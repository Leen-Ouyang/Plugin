help = ""
config = {
    msg = {
        begin="2023年8月31日   星期三    晴\n今天是进入大学的第一天,和其他普通的大学生一样,我对大学生活充满了好奇。我路过操场时不经意间瞥见几个身强力壮的学长,低头看着自己高中时被跑操捶打出来的健壮身躯,历经高考结束后的疯狂摸鱼而变得瘦弱,我开始担忧起自己的大学生活状态。此刻,“脆脆杀”和“超级大学人”的选择,摆在了我的面前。",
        intro="╔                                 ╗\n      脆脆杀的大学生活\n╚                                 ╝\n您好，我是大学的学生智能\nAI，现在请您配合我的工作，\n填写学生信息。",
        ask_name="请给我您的姓名" ,
        ask_gender="请选择性别「m/f」" ,
        ask_quality="请选择随机分配或自主分配主属性「rand/free」" ,
        ask_alter="分配成功,是否更改上述信息「y/n」" , 
        success="信息填入成功！输入「help」查看更多指令"       
    }
}
msg_order = {}
msg_order[] = ""

function createPlayer(event)
    local userQQ = event.sender.id
    -- 如果该用户qq号没有创建过角色，就创建角色
    if (userQQ) then
        begin()
        introduce()
        askName()
        getName(msg)
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
    a
end

function succeed()
    return config.msg.success
end