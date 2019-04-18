---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Chata.
--- DateTime: 2019/3/7 0:28
---

local Object=require "app.Object"
local Block=class("Block",Object)
--最大破坏次数
local MAX_BREAKABLE_STEP=3
local oriNode
local blockPropertyTable={
    --泥土
    ["mud"]={
        ["hp"]=0,
        --是否需要穿甲弹
        ["needAp"]=false,
        --阻力
        ["damping"]=0.2,
        --能否被破坏
        ["breakable"]=false
    },
    --路面
    ["road"]={
        ["hp"]=0,
        --是否需要穿甲弹
        ["needAp"]=false,
        --阻力
        ["damping"]=0,
        --能否被破坏
        ["breakable"]=false
    },
    --草
    ["grass"]={
        ["hp"]=0,
        --是否需要穿甲弹
        ["needAp"]=false,
        --阻力
        ["damping"]=0,
        --能否被破坏
        ["breakable"]=false
    },
    --水
    ["water"]={
        ["hp"]=0,
        --是否需要穿甲弹
        ["needAp"]=false,
        --阻力
        ["damping"]=1,
        --能否被破坏
        ["breakable"]=false
    },
    --砖块
    ["brick"]={
        ["hp"]=MAX_BREAKABLE_STEP,
        --是否需要穿甲弹
        ["needAp"]=false,
        --阻力
        ["damping"]=1,
        --能否被破坏
        ["breakable"]=true
    },
    --钢铁
    ["steel"]={
        ["hp"]=MAX_BREAKABLE_STEP,
        --是否需要穿甲弹
        ["needAp"]=true,
        --阻力
        ["damping"]=1,
        --能否被破坏
        ["breakable"]=true
    }
}

function Block:ctor(node,type)
    Block.super.ctor(self,node)
    if not oriNode then
        oriNode=node
    end
end

function Block:breakIt()
    --如果不能被破坏则返回
    if not self.breakable then
        return
    end
    self.hp=self.hp-1
    if self.hp<0 then
        self:reset("mud")
    else
        self:updateImage()
    end
end

function Block:updateImage(px,py)
    local sfc=cc.SpriteFrameCache:getInstance()
    local spriteName
    --如果能被破坏则显示对应的图片
    if self.breakable then
        spriteName=string.format("%s%d.png",self.type,MAX_BREAKABLE_STEP-self.hp)
    else
        spriteName=string.format("%s.png",self.type)
    end
    local frame=sfc:getSpriteFrame(spriteName)
    if frame==nil then
        print("sprite frame not found",self.type)
    else
        --每次新建一个精灵，用cocos的方法设置坐标
        self.sp=cc.Sprite:create()
        oriNode:addChild(self.sp)
        self.sp:setSpriteFrame(frame)
        self.sp:setPosition(px,py)
        if self.type=="grass" then
            --置于坦克之上
            self.sp:setLocalZOrder(10)
            --透明度
            self.sp:setOpacity(200)
        else
            self.sp:setLocalZOrder(0)
            --255表示不透明
            self.sp:setOpacity(255)
        end
    end
end

function Block:reset(type,px,py)
    local t=blockPropertyTable[type]
    assert(t,"方块错误--type:"..type)
    for i,e in pairs(t) do
        self[i]=e
    end
    self.type=type
    self:updateImage(px,py)
end

return Block