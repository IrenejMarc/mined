I doubt this will ever get finished, I just felt like trying it. Never worked with sockets much before this.

# Plans
 - Write an extensible Minecraft server in D
   - Extensions possibly done in a scripting language (possibly Python, maybe Lua, maybe just D modules)
   - Extensions should be able to provide (at least) map generators, mob AI, custom item behaviour, custom item physics, ...
 - Ability to support multiple Minecraft versions, even at the same time if possible
 - Huge modding API, hooks for various events
 - Officially supported systems should be OS X and Linux, with focus on Linux (possibly everything POSIX)
 - Windows support is optional but would be nice
 - Usage of dpq for PostgreSQL database bindings
   - Permissions in the DB
 - Basic configuration through either a .yml or .sdl file (preferrably .sdl)
 - If need be for a web-based control panel, implement it through vibe.d webserver, using a simple single-page-app (React or Ember preferred, absolutely no Angular of any version)
   
# Currently complete
 - The start of the SSL handshake
 - Support for thread-less connection of players, allowing for a huge amount of players to be on at the same time through select() polling
 
# Priorities for the moment
 - Server list ping
 - Basic login, basic map (flat grass) generator
 - Chat
 - Refactoring the state machine into functions, not structs, they need no state

# Developer information
## Resources
 - http://wiki.vg/Main_Page
 
## Style guide (important)
 - Style is mostly Allman
   - Tabs for indentation, spaces for alignment
   - Two tabs for a continuation indent
   - Spaces after keyword flow modifiers (for, if, while, ...)
   - Braces `{ }` on their own lines!
   - No spaces inside parentheses `()`
 - D-related styles
   - camelCased variables, methods, and functions
   - PascalCased structures (classes, structs)
   - Structs should be preferred over classes when GC is not needed or preferred
   - Use foreach when possible and sensible, this includes `foreach (i; 0 .. someNumber)`
   - Functional programming is preferred when it makes code more understandable (`someArr.map!"a.someProperty + a.id"`, `someOtherArr.sum()`)
   - Parentheses should be used on method calls when any work is being done (this does not include `@property` values)
   - Sensible naming is required, PRs with single-letter variable names will be denied
   - Refactor early, refactor often; it's impossible to know how big this project will get, so keep it maintainable
   
## Other styles and preferences
 - JSON and simple REST APIs are always preferred for any kind of outside data sharing
 - PostgreSQL is very much preferred over other DB systems
 
## Developer chat
 - If enough developers join us, we might create a chat group (Skype, Telegram, Slack, Discord, anything)
## Editors
 - Use Vim if you like yourself, emacs if you hate yourself and your wrists.
