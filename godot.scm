;;
;; (c) Andrew Filonov   <andrew.filonov@gmail.com>
;;
;; --------------------------------------------------------------------------------------------
(define (export-png-withflags img drawable pngname mipmap)
     (if (= 1 mipmap)
	  (let ( (outport (open-output-file (string-append pngname ".flags" ))))
	     (display "gen_mipmaps=false\n" outport)
	     (close-output-port outport))
	  ((display " no image flags generated\n")))
      (file-png-save-defaults 1 img drawable pngname pngname))
;; --------------------------------------------------------------------------------------------
(define (write-node  outport . s)
  (define (write-item   s)
    (display s outport))
  (for-each write-item s ))
;; --------------------------------------------------------------------------------------------
(define (write-sprite outport  name x y w h pos_x pos_y)
  (write-node outport "[node name=\"" name "\" type=\"Sprite\" parent=\".\"]\n\n"
	      "transform/pos = Vector2(" pos_x ", " pos_y " )\n"
	      "texture = ExtResource( 1 )\nregion = true\n"
	      "region_rect = Rect2( " x ", " y ", " w ", " h " )\n\n"))
;; --------------------------------------------------------------------------------------------
(define (write-scene-header outport resname)
  (write-node  outport "[gd_scene load_steps=2 format=1]\n\n")
  (write-node  outport "[ext_resource path=\"res://" resname ".png\" type=\"Texture\" id=1]\n\n" )
  (write-node  outport "[node name=\"Node2D\" type=\"Node2D\"]\n\n" ))


;; --------------------------------------------------------------------------------------------
(define (godot-create-tscn img drawable w h off_x off_y prefix dirname resname  mipmap )
  (let * (
	  (img_w (car (gimp-image-width img)))
	  (img_h (car (gimp-image-height img)))
	  (tname (string-append  dirname DIR-SEPARATOR  resname ".tscn"))
	  (pngname (string-append  dirname DIR-SEPARATOR resname ".png"))
	  (i 0))

    (export-png-withflags img drawable pngname mipmap)
    (define outport (open-output-file tname))
    (write-scene-header outport resname)

    (do (( y off_y (+ h y )))
	((>= y img_h))
      (do (( x off_x (+ w x)))
	  ((>= x img_w))
	(write-sprite outport
		      (string-append prefix (number->string i))
		      x y w h
		      (+ x  (/ w 2))
		      (+ y  (/ h 2)))
	(set! i (+ 1 i))))
    (close-output-port outport)
    (gimp-message (string-append "Writing png to " pngname " and scene to " tname ))))
;; --------------------------------------------------------------------------------------------
(define (godot-create-sprites img drawable direction  prefix dirname resname mipmap close_image)
  (let * ((tname (string-append  dirname DIR-SEPARATOR  resname ".tscn"))
	  (pngname (string-append  dirname DIR-SEPARATOR resname ".png"))
	  (img_w (car (gimp-image-width img)))
	  (img_h (car (gimp-image-height img)))
	  (new_image (car (gimp-image-duplicate img)))
	  (numlayers 0)
	  (layers 0)
	  (layer 0)
	  (x 0)
	  (y 0)
	  (off_x 0)
	  (off_y 0))
    (set! numlayers (car (gimp-image-get-layers new_image)))
    (set! layers    (cadr(gimp-image-get-layers new_image)))
    (if (= direction 1 ) (set! off_y img_h)  (set! off_x img_w))
    (define outport (open-output-file tname))
    (write-scene-header outport resname)
    (do (( i 0 (+ 1 i)))
	(( >= i numlayers))
      (set! layer (aref layers (- (- numlayers 1) i)))
      (gimp-layer-translate layer x y)
      (write-sprite outport
		    (string-append prefix (number->string i) "_" (car(gimp-item-get-name layer)))
		    x y img_w img_h
		    (+ x  (/ img_w 2))
		    (+ y  (/ img_h 2)))
      (set! x (+ off_x x))
      (set! y (+ off_y y)))
    (close-output-port outport)
    (gimp-image-resize-to-layers new_image)
    (gimp-image-merge-visible-layers new_image EXPAND-AS-NECESSARY)
;    (export-png-withflags new_image
;	      (car(gimp-image-active-drawable new_image))
;	      pngname  mipmap)
    (if (= 0 close_image)
	(gimp-display-new new_image)
	(gimp-image-delete new_image))
    (gimp-message (string-append "Writing png to " pngname " and scene to " tname ))))

(script-fu-register "godot-create-tscn"
		    _"<Toolbox>/Xtns/Godot/Create Sprite set from image..."
		    "Save png and tscn file for Godot engine into selected directory based on current image"
		    "Andrew Filonov <andrew.filonov@gmail.com>"
		    "andrew.filonov@gmail.com"
		    "2016"
		    ""
		    SF-IMAGE        "Image to use"          0
		    SF-DRAWABLE     "Layer to use"          0
		    SF-VALUE   "Width" "32"
		    SF-VALUE   "Height" "32"
		    SF-VALUE   "Offset X" "0"
		    SF-VALUE   "Offset Y" "0"
		    SF-STRING   "Sprite Name prefix" "s"
		    SF-DIRNAME "Project Directory" ""
		    SF-STRING   "Base name" "tileset"
		    SF-OPTION   "Turn off mipmap generation"          '("No" "Yes")
		    )
(script-fu-register "godot-create-sprites"
		    _"<Toolbox>/Xtns/Godot/Create Image from Layers..."
		    "Creates a new sprite set from current image layers and generate scene file. Layer's names will be used in sprite names"
		    "Andrew Filonov <andrew.filonov@gmail.com>"
		    "andrew.filonov@gmail.com"
		    "2016"
		    ""
		    SF-IMAGE        "Image to use"          0
		    SF-DRAWABLE     "Layer to use"          0
		    SF-OPTION        "Direction"          '("Horizontal" "Vertical")
		    SF-STRING   "Sprite Name prefix" "s"
		    SF-DIRNAME  "Project Directory" ""
		    SF-STRING   "Base name" "tileset"
		    SF-OPTION   "Turn off mipmap generation"          '("No" "Yes")
		    SF-OPTION   "Show Image"          '("Yes" "No")
		    )
