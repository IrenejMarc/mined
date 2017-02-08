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
   
# Currently complete
 - The start of the SSL handshake
 - Support for thread-less connection of players, allowing for a huge amount of players to be on at the same time through select() polling
 
# Priorities for the moment
 - Server list ping
 - Basic login, basic map (flat grass) generator
 - Chat
 - Refactoring the state machine into functions, not structs, they need no state
