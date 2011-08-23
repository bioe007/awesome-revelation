-- revelation.lua
--
-- Library that implements Expose like behavior.
--
-- @author Perry Hargrave resixian@gmail.com
-- @author Espen Wiborg espenhw@grumblesmurf.org
-- @author Julien Danjou julien@danjou.info
--
-- @copyright 2008 Espen Wiborg, Julien Danjou
--

local awful = awful
local pairs = pairs
local setmetatable = setmetatable
local table = table
local capi = {
    tag = tag,
    client = client,
    keygrabber = keygrabber,
    mouse = mouse,
    screen = screen
}

module("revelation")

-- FIXME: Now unused filter to grab clients based on their class.
--
-- @param class the class string to find
-- @s the screen
--
function clients(class, s)
    local clients
    if class then
        clients = {}
        for k, c in pairs(capi.client.get(s)) do
            if c.class == class then
                table.insert(clients, c)
            end
        end
    else
        clients = capi.client.get(s)
    end
    return clients
end

-- Executed when user selects a client from expose view.
--
-- @param restore Function to reset the current tags view.
function selectfn(restore)
    return function(c)
        restore()
        -- Pop to client tag
        awful.tag.viewonly(c:tags()[1], c.screen)
        -- Focus and raise
        capi.client.focus = c
        c:raise()
    end
end

-- Arrow keys and 'hjkl' move focus, Return selects, Escape cancels. Ignores
-- modifiers.
--
-- @param restore a function to call if the user presses escape
-- @return keyboardhandler
function keyboardhandler (restore)
    return function (mod, key, event)
        if event ~= "press" then return true end
        -- translate vim-style home keys to directions
        if key == "j" or key == "k" or key == "h" or key == "l" then
            if key == "j" then
                key = "Down"
            elseif key == "k" then
                key = "Up"
            elseif key == "h" then
                key = "Left"
            elseif key == "l" then
                key = "Right"
            end
        end

        --
        if key == "Escape" then
            restore()
            return false
        elseif key == "Return" then
            selectfn(restore)(capi.client.focus)
            return false
        elseif key == "Left" or key == "Right" or
            key == "Up" or key == "Down" then
            awful.client.focus.bydirection(key:lower())
        end
        return true
    end
end

-- Implement Exposé (ala Mac OS X).
--
-- @param class The class of clients to expose, or nil for all clients.
-- @param fn A binary function f(t, n) to set the layout for tag t for n
--           clients, or nil for the default layout.
-- @param s The screen to consider clients of, or nil for "current screen".
function expose(class, fn, s)
    local scr = s or capi.mouse.screen
    local t = capi.screen[scr]:tags()[1]
    local oldlayout = awful.tag.getproperty( t, "layout" )

    awful.tag.viewmore( capi.screen[scr]:tags(), t.screen )
    awful.layout.set(awful.layout.suit.fair,t)

    local function restore()
        awful.layout.set(oldlayout,t)
        awful.tag.viewonly(t)

        capi.keygrabber.stop()
    end

    capi.keygrabber.run(keyboardhandler(restore))
end

setmetatable(_M, { __call = function(_, ...) return expose(...) end })
