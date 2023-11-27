PROJECT = "remote_car"
VERSION = "1.0.0"

sys = require("sys")
require("sysplus")

if wdt then
    wdt.init(9000)
    sys.timerLoopStart(wdt.feed, 3000)
end

local wheel_front_left = gpio.setup(7, 0, gpio.PULLUP)
local wheel_front_right = gpio.setup(6, 0, gpio.PULLUP)
local wheel_back_left = gpio.setup(10, 0, gpio.PULLUP)
local wheel_back_right = gpio.setup(3, 0, gpio.PULLUP)

local wheel_front_left_on = false
local wheel_front_right_on = false
local wheel_back_left_on = false
local wheel_back_right_on = false

-- speed rang: [0..10]
local speed = 10

local humid, temp, result

sys.taskInit(function()
    while true do
        if wheel_front_left_on then
            local on_time = speed
            local off_time = 10 - speed
            wheel_front_left(1)
            sys.wait(on_time)
            -- log.info("wheel front left on", wheel_front_left_on)
            if off_time > 0 then
                -- log.info("off", off_time)
                wheel_front_left(0)
                sys.wait(off_time)
            end
        else
            wheel_front_left(0)
            sys.wait(201)
        end
    end
end)

sys.taskInit(function()
    while true do
        if wheel_front_right_on then
            local on_time = speed
            local off_time = 10 - speed
            wheel_front_right(1)
            sys.wait(on_time)
            if off_time > 0 then
                -- log.info("off", off_time)
                wheel_front_right(0)
                sys.wait(off_time)
            end
        else
            wheel_front_right(0)
            sys.wait(201)
        end
    end
end)

sys.taskInit(function()
    while true do
        if wheel_back_left_on then
            local on_time = speed
            local off_time = 10 - speed
            wheel_back_left(1)
            sys.wait(on_time)
            if off_time > 0 then
                -- log.info("off", off_time)
                wheel_back_left(0)
                sys.wait(off_time)
            end
        else
            wheel_back_left(0)
            sys.wait(201)
        end
    end
end)

sys.taskInit(function()
    while true do
        if wheel_back_right_on then
            local on_time = speed
            local off_time = 10 - speed
            wheel_back_right(1)
            sys.wait(on_time)
            if off_time > 0 then
                -- log.info("off", off_time)
                wheel_back_right(0)
                sys.wait(off_time)
            end
        else
            wheel_back_right(0)
            sys.wait(201)
        end
    end
end)

sys.taskInit(function()
    sys.wait(1000)

    wlan.init()
    -- create new AP
    local ssid = "Luck_" .. wlan.getMac()
    local password = "12341234"
    wlan.createAP(ssid, password)
    log.info("AP", ssid, password)

    sys.wait(500)

    -- start the http sever at http://192.168.4.1/
    httpsrv.start(80, function(client, method, uri, headers, body)
        log.info("client", client)
        log.info("method", method)
        log.info("uri", uri)
        log.info("header", json.encode(headers))
        log.info("raw header", headers)
        log.info("body", body)

        if uri == "/wheel/front_left" then
            if body == "on" then
                -- wheel_front_left(1)
                wheel_front_left_on = true
                log.info("wheel", "turn on", "front_left")
                return 200, {}, ""
            else
                -- wheel_front_left(0)
                wheel_front_left_on = false
                log.info("wheel", "turn off", "front_left")
                return 200, {}, ""
            end

        elseif uri == "/wheel/front_right" then
            if body == "on" then
                -- wheel_front_right(1)
                wheel_back_right_on = true
                log.info("wheel", "turn on", "front_right")
                return 200, {}, ""
            else
                -- wheel_front_right(0)
                wheel_back_right_on = false
                log.info("wheel", "turn off", "front_right")
                return 200, {}, ""
            end

        elseif uri == "/wheel/back_left" then
            if body == "on" then
                -- wheel_back_left(1)
                wheel_back_left_on = true
                log.info("wheel", "turn on", "back_left")
                return 200, {}, ""
            else
                -- wheel_back_left(0)
                wheel_back_left_on = false
                log.info("wheel", "turn off", "back_left")
                return 200, {}, ""
            end

        elseif uri == "/wheel/back_right" then
            if body == "on" then
                -- wheel_back_right(1)
                wheel_back_right_on = true
                log.info("wheel", "turn on", "back_right")
                return 200, {}, ""
            else
                -- wheel_back_right(0)
                wheel_back_right_on = false
                log.info("wheel", "turn off", "back_right")
                return 200, {}, ""
            end

        elseif uri == "/wheel/stop" then
            log.info("wheel", "stop")
            -- wheel_front_left(0)
            -- wheel_front_right(0)
            -- wheel_back_left(0)
            -- wheel_back_right(0)
            wheel_front_left_on = false
            wheel_front_right_on = false
            wheel_back_left_on = false
            wheel_back_right_on = false
            return 200, {}, ""

        elseif uri == "/wheel/forward" then
            log.info("wheel", "forward")
            -- wheel_front_left(0)
            -- wheel_front_right(0)
            -- wheel_back_left(1)
            -- wheel_back_right(1)
            wheel_front_left_on = false
            wheel_front_right_on = false
            wheel_back_left_on = true
            wheel_back_right_on = true
            return 200, {}, ""

        elseif uri == "/wheel/back" then
            log.info("wheel", "back")
            -- wheel_front_left(1)
            -- wheel_front_right(1)
            -- wheel_back_left(0)
            -- wheel_back_right(0)
            wheel_front_left_on = true
            wheel_front_right_on = true
            wheel_back_left_on = false
            wheel_back_right_on = false
            return 200, {}, ""

        elseif uri == "/wheel/left" then
            log.info("wheel", "left")
            -- wheel_front_left(1)
            -- wheel_front_right(0)
            -- wheel_back_left(0)
            -- wheel_back_right(1)
            wheel_front_left_on = true
            wheel_front_right_on = false
            wheel_back_left_on = false
            wheel_back_right_on = true
            return 200, {}, ""

        elseif uri == "/wheel/right" then
            log.info("wheel", "right")
            -- wheel_front_left(0)
            -- wheel_front_right(1)
            -- wheel_back_left(1)
            -- wheel_back_right(0)
            wheel_front_left_on = false
            wheel_front_right_on = true
            wheel_back_left_on = true
            wheel_back_right_on = false
            return 200, {}, ""

        elseif uri == "/wheel/speed" then
            speed = tonumber(body)
            log.info("wheel", "speed", speed)
            return 200, {}, ""

        elseif uri == "/sensor/temp" then
            log.info("sensor", "temp", humid, temp, result)

            return 200, {}, tostring(humid) .. " " .. tostring(temp)

        end

        return 404, "Not Found" .. uri
    end)

end)

sys.taskInit(function()
    while true do
        sys.wait(2000)

        local tmp_humid, tmp_temp, result = sensor.dht1x(12)
        if result then
            humid = tmp_humid
            temp = tmp_temp
            -- log.info("sensor", "temp", humid, temp, result)
        end

    end

end)

sys.run()
