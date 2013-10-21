Assetfy for [Starling Framework](https://github.com/PrimaryFeather/Starling-Framework)
Assetfy is a open source library that converts flash DisplayObjectContainer into Starling data object formats.
Work with filters!
Work with color effects!
Work with color matrix!
Work, work, WORK!...

## Requirements
You need to add the Starling lib in your project.
Tested on Starling 1.4.1

## Project
    types
        Bitmap // Flaten container and converts to Bitmap Object
        Image // Flaten container and converts to Starling Image Object
        Texture // Flaten container and converts to Starling Texture Object
        TextureAtlas // Flaten container and converts to Starling TextureAtlas Object
        Assetfy MovieClip // Converts Flash MovieClip into Assetfy MovieClip Object (Saves a lot of memory!)

    Classes
        MovieClip
            - frame (frame-number / label name)
            - loop (animation name, mode [reverse, normal])
            - play (animation name, [[mode [reverse, normal] | onComplete], onComplete])
            - stop ()
            - add (SheetData)
            - set/get FPS
        MovieClipData
            - name
            - frames (array | frame number from, frame number to)

    Assetfy
        - me (DisplayObject, type [Bitmap, MovieClip])
        - content (DisplayObjectContainer with Assetfy childs interface class):Object
