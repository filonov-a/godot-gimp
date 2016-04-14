# Some useful GIMP scripts for generating spritesets/tilesets for Godot engine

Put godot.scm into ~/.gimp-2.X/scripts/ directory and press
Filters -> Scripts-Fu -> Refresh Scripts (or just restart gimp)

In Menu:
##Filters -> Godot -> "Create Image from Layers"
Create new image from all layer of current image, and 
save as .png into project directory.
Also create .tscn with sprite definition for every layer.
If you can choose "Turn off mipmap generation", .png.flags file also will be created
with /"gen_mipmaps=false"/ option
![Example](https://filonov-a.github.io/godot-gimp/examples/Image_from_layers.png)


##Filters -> Godot -> "Create Sprite set from image"
Split current image into set of sprites and generate .tscn file with definition of
all sprites. Export current image as .png into project directory.


## License

Licensed under MIT license.
