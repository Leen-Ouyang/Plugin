shop = "shop"
config = {
    msg = {
        shopmenu="╔═══════════════╗\n            远程商店\n  ——————————\n   指令     效果\n 「pnt」 积分商店\n 「achi」成就商店\n 「spec」 特殊商店\n╚═══════════════╝\ntips:特殊事件所需部分物件\n         需要从特殊商店购买"
    }
}
msg_order = {}
msg_order[shop] = "Shopmenu"
function Shopmenu()
    return config.msg.shopmenu
end