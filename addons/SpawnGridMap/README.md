# SpawnGridMap for Godot
_An extendsion for GridMap to allow scenes to be instanced in place at runtime._

## Installation

1. Download and extract all files into your godot project addons folder so the project path is: `res://addons/SpawnGridMap`

2. Enable **SpawnGridMap** through the Plugins window under Project Settings


## Using The Addon

### Creating A MeshLibrary

Follow the steps in the [godot GridMap tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) as your would for any other GridMap usage. Make surea# SpawnGridMap for Godot
_An extendsion for GridMap to allow scenes to be instanced in place at runtime._


## Installation

1. Download and extract all files into your godot project addons folder so the project path is: `res://addons/SpawnGridMap`

2. Enable **SpawnGridMap** through the Plugins window under Project Settings


## Creating A MeshLibrary

Follow the steps in the [godot GridMap tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) as your would for any other GridMap usage. Make sure to save the scene you used to create the MeshLibrary for later use. We'll call this the **map scene** from now on.

In the map scene, for any mesh you wish to replace with a scene instance, attach the `SpawnGridMapSpawner` script and specify the instance. SpawnGridMap will replace this tile with an instance at run time.

Export the MeshLibrary and save the scene when you're done.


## Adding it to a scene

The SpawnGridMap is available as a node type, it extends from GridMap and is used the same way.

Once it's in your scene, assign the **map scene** you used to create the mesh library to the `map_scene` property of the SpawnGridMap.

That's it!

SpawnGridMap will replace your tiles with instances at runtime.


 ## Scaled and rotated spawning

 Objects can be spawned to match the rotation or scale of the GridMap tile by setting `use_map_orientation` and `use_map_scale` on the `SpawnGridMapSpawner` respectively.  


## Respawning

You can use `SpawnGridMapSpawner` to allow objects to respawn after a certain time and/or when the last instance is destroyed or travels a certain distance from the spawner. To allow respawning:
 - Set `use_respawn` to true
 - Set the `respawn_time` property to something greater than zero
 - If you wish to use distance spawning, set the `respawn_distance` property to something greater than zero.

 ## Picking from multiple scenes

 If you specify multiple scenes, by default the spawner will work through them in order, repeating. You can, however, allow for random selection by settingsetting `spawn_random` to true.

 You can influence the random selection by adding `scene_weights` at the corresponding scene index and by setting `random_seed`.
 to save the scene you used to create the MeshLibrary for later use. We'll call this the **map scene** from now on.

In the map scene, for any mesh you wish to replace with a scene instance, attach the `SpawnGridMapSpawner` script and specify the instance. SpawnGridMap will replace this tile with an instance at run time.

Export the MeshLibrary and save the scene when you're done.

### Adding it to a scene

The SpawnGridMap is available as a node type, it extends from GridMap and is used the same way.

Once it's in your scene, assign the **map scene** you used to create the mesh library to the `map_scene` property of the SpawnGridMap.

### That's it!

SpawnGridMap will replace your tiles with instances at runtime.

## Respawning

You can use `SpawnGridMapSpawner` to allow objects to respawn after a certain time and/or when the last instance is destroyed or travels a certain distance from the spawner. To allow respawning:
 - Set `use_respawn` to true
 - Set the `respawn_time` property to something greater than zero
 - If you wish to use distance spawning, set the `respawn_distance` property to something greater than zero.

 ## Picking from multiple scenes

 If you specify multiple scenes, by default the spawner will work through them in order, repeating. You can, however, allow for random selection by settingsetting `spawn_random` to true.

 You can influence the random selection by adding `scene_weights` at the corresponding scene index and by setting `random_seed`.


## Demo Project

A demo project has been [added to Github](https://github.com/daleblackwood/SpawnGridMapDemo) with a reference implementation. Check it out, but be sure to get the actual source from here as this will be more frequently updated.
