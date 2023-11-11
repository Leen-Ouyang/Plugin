help = "help"
config = {
    msg = {
        mainmenu="╔═══════════════╗\n            指令档案\n  ——————————\n      输入指令查看详细\n  ——————————\n   指令     效果\n 「info」打开个人档案\n 「mod」 书写个人简介\n 「chat」社交\n 「cred」打开学分档案\n 「add」  查看新解锁内容\n 「achi」打开成就档案\n 「pnt」  打开积分档案\n 「shop」打开远程商店\n 「bag」  打开远程背包\n╚═══════════════╝\ntips:输入「特殊指令」\n         可解锁某些成就"
    }
}
msg_order = {}
msg_order[help] = "Menu"
function Menu()
    return config.msg.mainmenu
end