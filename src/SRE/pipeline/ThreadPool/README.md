# MultiThreadingPool Luau
Multithreading pool made for Roblox.

## Why?
For my use case, I need to queue many tasks with the ability to control the number of actors. So, I made this library which will queue tasks that use the same function and then get executed by a free actor. 

## Constructors
### CreateThreadPool()
```lua
local threadpool = ThreadPool.CreateThreadPool(threads, modulescript, sharedTable, callbackFunction)
```
- threads: number of actors created.
- modulescript: modulescript that will be required and used to execute tasks under actors.
- sharedTable: Global state table that all actors can access.
- callbackFunction: Returned values from actors can be recieved here.

## Methods
### threadpool:QueueTask()
```lua
threadpool:QueueTask(tuple)
```
- tuple: Any number of arguments that will be recieved by the given modulescript, which is bound to the actor.

### threadpool:Join()
```lua
threadpool:Join()
```
Yields the current thread until all queued tasks have been executed by the actors.

### threadpool:Destroy()
```lua
threadpool:Destroy()
```
Waits for all queued tasks to finish before destroying the threadpool object.

### threadpool:ForceDestroy()
```lua
threadpool:ForceDestroy()
```
Destroys the threadpool object.
