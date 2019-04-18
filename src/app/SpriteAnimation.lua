---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Chata.
--- DateTime: 2019/3/5 21:03
---

local SpriteAnimation=class("SpriteAnimation")

function SpriteAnimation:ctor(sp)
    --动画表
    self.anim={}
    self.sp=sp
end

local function setFrameByFormat(sp,def,index)
    if sp==nil then
        return
    end
    local sfc=cc.SpriteFrameCache:getInstance()
    local final
    --匹配资源
    if def.name~=nil then
        final=string.format("%s_%s%d.png",def.spname,def.name,index)
    else
        final=string.format("%s%d.png",def.spname,index)
    end
    local frame=sfc:getSpriteFrame(final)
    if frame==nil then
        print("找不到对应的图片",name)
        return
    end
    sp:setSpriteFrame(frame)
end

function SpriteAnimation:define(name,spname,frameCount,interval,once)
    local sfc=cc.SpriteFrameCache:getInstance()
    local def={
        ["curFrame"]=0,
        ["running"]=false,
        ["frameCount"]=frameCount,
        ["spname"]=spname,
        ["name"]=name,
        ["once"]=once,
        ["interval"]=interval,
        ["advFrame"]=function(defSelf)
            defSelf.curFrame=defSelf.curFrame+1
            if defSelf.curFrame>=defSelf.frameCount then
                defSelf.curFrame=0
                return false
            end
            return true
        end
    }
    if name== nil then
        self.anim[spname]=def
    else
        self.anim[name]=def
    end
end

function SpriteAnimation:setFrame(name,index)
    local def=self.anim[name]
    if def==nil then
        return
    end
    setFrameByFormat(self.sp,def,index)
end

function SpriteAnimation:play(name,callback)
    local def=self.anim[name]
    if def==nil then
        return
    end
    if def.shid==nil then
        def.shid=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
            if def.running then
                if def:advFrame() then
                    setFrameByFormat(self.sp,def,def.curFrame)
                elseif def.once then
                    def.running=false
                    cc.Director:getInstance():getScheduler():unscheduleScriptFunc(def.shid)
                    def.shid=nil
                    if callback~= nil then
                        callback()
                    end
                end
            end
        end,def.interval,false)
    end
    def.running=true
end

function SpriteAnimation:stop(name)
    local def=self.anim[name]
    if def ==nil then
        return
    end
    def.running=false
end

function SpriteAnimation:destory()
    for name,def in pairs(self.anim) do
        if def.shid then
            cc.Director:getInstance():getScheduler():unscheduleScriptFunc(def.shid)
        end
    end
    self.sp=nil
end

return SpriteAnimation