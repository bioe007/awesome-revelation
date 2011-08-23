# revelation.lua

Provides Mac OSX like 'Expose' view of all clients.

## Use
 (From user's awesome configuration directory, usually ~/.config/awesome)

 1. Clone repository:

        git clone https://bioe007@github.com/bioe007/awesome-revelation.git

 2. put near the top of your rc.lua require("revelation")
 3. Make a global keybinding for revelation in your rc.lua:

          awful.key({modkey}, "e", revelation)

    **NOTE:** Always double check this key binding syntax against the version of
    Awesome that you are using.

 4. Reload rc.lua and try the keybinding.

 It should bring all clients to the current tag and set the layout to fair. You
 can focus clients with __cursor__ or __hjkl__ keys then press __Enter__ to
 select or __Escape__ to abort.

 This is a modification of the original awesome library that implemented
 expose like behavior.

## Credits

    * Perry Hargrave resixian@gmail.com
    * Espen Wiborg espenhw@grumblesmurf.org
    * Julien Danjou julien@danjou.info

## License
 (c) 2008 Espen Wiborg, Julien Danjou
