# Полезные скрипты для Godot engine

Поместите godot.scm в ~/.gimp-2.X/scripts/ 


##Фильтры -> Godot -> "Create Image from Layers.."

Для многослойной картинки создается новое изображение
которое содержит слои исходного изображения по горизонтали или вертикали.
Изображение сохраняется в папку проекта, туда же генерится tcsn-файл
который содержит описание все спрайтов. При генерации имен спрайтов используются имена слоев.
![Example](https://filonov-a.github.io/godot-gimp/examples/Image_from_layers.png)

##Фильтры -> Godot -> "Create Sprite set from image"

Нарезает текущее изображение в набор спрайтов заданного размера.

##Фильтры -> Godot -> "Split layer to separate images"

Сохраняет текущее многослойное изображение в набор png-файлов.


## License

Licensed under MIT license.
