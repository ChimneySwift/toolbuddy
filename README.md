# Toolbuddy
Provides alerts for low tool HP.

## Commands
### toolbuddy enable | disable | help | level
Will display a colored chat message to the user when the wear of the tool being used goes above a given level.

Use `.toolbuddy help` to display a help message
Use `.toolbuddy enable` to enable warnings (default)
Use `.toolbuddy disable` to disable warnings
Use `.toolbuddy level <1-99>` to set the warning level. Higher is more worn (default = 90)

## How to install
1. Enter your minetest directory.
2. Find the `clientmods` directory.
3. Unpack this mod into that directory.
4. Rename unpacked directory (should be named `toolbuddy-master`) to `toolbuddy`.
5. Set the in-game setting `enable_client_modding` to true.
6. You're done!

## License
Code: **MIT License**

## Notes
-Will work on any tool which is used or punches a block. Check items like armor by punching a block with it.

-Saves state (enabled or disabled) and wear level to modstorage.

## Todo
-Make test warnings appear in HUD element (Limited by API)

-Also test armor being worn (Limited by API)

-Reset `last_wear` whenever the user changes the held item (Limited by API, currently will reset whenever a different tool is used)
