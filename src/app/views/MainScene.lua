require "app.Common"
local Map=require "app.Map"
local Tank=require "app.Tank"
local PlayerTank=require "app.PlayerTank"
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()

    --获取图片资源
    local sfc=cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("res/test.plist")

    self.map=Map.new(self)

    local size=cc.Director:getInstance():getWinSize()
    --创建一台坦克
    self.tank=PlayerTank.new(self,"tank_green",self.map)
    --self.tank.sp:setPosition(size.width/2,size.height/2)
    --self.tank.sp:setPos(5,5)
    self:processInput()
end

function MainScene:processInput()
    local listener=cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(function(keyCode,event)
        if self.tank~=nil then
            if keyCode==146 then
                self.tank:moveBegin("up")
            elseif keyCode==142 then
                self.tank:moveBegin("down")
            elseif keyCode==124 then
                self.tank:moveBegin("left")
            elseif keyCode==127 then
                self.tank:moveBegin("right")
            end
        end
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)

    listener:registerScriptHandler(function(keyCode,event)
        if self.tank~=nil then
            if keyCode==146 then
                self.tank:moveEnd("up")
            elseif keyCode==142 then
                self.tank:moveEnd("down")
            elseif keyCode==124 then
                self.tank:moveEnd("left")
            elseif keyCode==127 then
                self.tank:moveEnd("right")
            end
        end
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher=self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

return MainScene
