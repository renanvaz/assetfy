# Assetfy for [Starling Framework](https://github.com/PrimaryFeather/Starling-Framework)
Assetfy is a open source library that converts flash MovieClip into Starling object formats.
You can do your animations with Flash Professional IDE and exports SWF or a SWC file to use in your Starling project.

## Its easy! Its simple! Its awesome!

```actionscript
    // AssetfyMovieClip Example
    var mc:MyFlashMovieClip         = new MyFlashMovieClip;
    var assetfyMc:AssetfyMovieClip  = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);
    assetfyMc.loop('default');

    addChild(assetfyMc);

    // TextureAtlas Example
    var mc:MyFlashMovieClip     = new MyFlashMovieClip;
    var ta:TextureAtlas         = Assetfy.me(mc, Assetfy.types.TEXTURE_ATLAS); // return starling TextureAtlas
    var starlingMc:MovieClip    = new MovieClip(ta.getTextures('default'), Starling.current.nativeStage.frameRate); // Starling MovieClip

    Starling.juggler.add(starlingMc);

    addChild(starlingMc);
```

### Features
You can convert the MovieClip to any formats:
    Bitmap              (flash.dysplay.Bitmap)
    Texture             (starling.textures.Texture)
    Image               (starling.dysplay.Image)
    TextureAtlas        (starling.textures.TextureAtlas)
    AssetfyMovieClip    (assetfy.display.AssetfyMovieClip)

### Requirements
You need to add the Starling lib in your project.
Tested on Starling 1.4.1

## Documentation

### Methods
The Assetfy class have 2 statics methods

```actionscript
    Assetfy.me(mc:MovieClip, returnType:String);
    Assetfy.childs(container:DisplayObjectContainer);
```

returnType values

```actionscript
    Assetfy.types.BITMAP
    Assetfy.types.TEXTURE
    Assetfy.types.IMAGE
    Assetfy.types.TEXTURE_ATLAS
    Assetfy.types.ASSETFY_MOVIECLIP
```

### The Assetfy.me method

```actionscript
    var mc:MyFlashMovieClip         = new MyFlashMovieClip;

    // Converts all the frames to a Assetfy AssetfyMovieClip (Best performance in a simple and wonderfull API)
    var assetfyMc:AssetfyMovieClip  = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);

    // Converts all the frames to a Starling TextureAtlas (Sprite Texture and XML coordinates)
    var ta:TextureAtlas             = Assetfy.me(mc, Assetfy.types.TEXTURE_ATLAS);

    // Converts the current frame to a Starling Image
    var Image:Image                 = Assetfy.me(mc, Assetfy.types.IMAGE);

    // Converts the current frame to a Starling Texture
    var t:Texture                   = Assetfy.me(mc, Assetfy.types.TEXTURE);

    // Converts the current frame to a Flash Bitmap
    var bm:Bitmap                   = Assetfy.me(mc, Assetfy.types.BITMAP);
```

### The Assetfy.childs method
    // Documentation is comming...

### The AssetfyMovieClip object
```actionscript
    // You can set the FPS at anytime
    assetfyMc.fps = 60; // A integer number of indicate the FPS of the AssetfyMovieClip

    /**
     * assetfyMc.play(label:String [, fps:int]):AssetfyMovieClip
     */
    // You can play a animation once
    assetfyMc.play('animation_name');

    // You can play a animation once and set the FPS
    assetfyMc.play('animation_name', 24);

    // You can play a animation once with a callback
    assetfyMc
        .play('animation_name', 24)
        .onComplete(function():void { trace('Animation complete!'); });

    /**
     * assetfyMc.loop(label:String [, fps:int]):void
     */
    // You can play a animation in loop
    assetfyMc.loop('animation_name');

    // You can play a animation in loop and set the FPS
    assetfyMc.loop('animation_name', 24);

    ...
    // You can pause the current animation
    assetfyMc.pause();

    // You can resume the current animation
    assetfyMc.resume();

    // You can stop the current animation (reset frame index)
    assetfyMc.stop();
```

### Why AssetfyMovieClip is not simply called MoiveClip?
AssetfyMovieClip has a personal API, so there is no risk of confusion with the Starling MovieClip instance and API.

## How to prepare the flash MovieClip to be converted by Assetfy?
Assetfy uses the label property to assign TextureAtlas and AssetfyMovieClip animations, if the label property is not set, Assetfy will use the name as "default".


## Starling normal workflow comparation

```actionscript
    // Without Assetfy
    [Embed(source="atlas.xml", mimeType="application/octet-stream")]
    public static const AtlasXml:Class;

    [Embed(source="atlas.png")]
    public static const AtlasBitmap:Class;

    ...

    var xml:XML                 = XML(new AtlasXml);
    var t:Texture               = Texture.fromBitmap(new AtlasBitmap);
    var ta:TextureAtlas         = new TextureAtlas(t, xml);
    var starlingMc:MovieClip    = new MovieClip(ta.getTextures('default'), Starling.current.nativeStage.frameRate);

    starlingMc.loop = false;
    starlingMc.addEventListener(Event.COMPLETE, function(){ trace('Animation complete') });

    Starling.juggler.add(starlingMc);

    addChild(starlingMc);

    // With Assetfy (You can embed SWF from code, SWC file or load a external file)
    var mc:MyFlashMovieClip     = new MyFlashMovieClip;
    var ta:TextureAtlas         = Assetfy.me(mc, Assetfy.types.TEXTURE_ATLAS);
    var starlingMc:MovieClip    = new MovieClip(ta.getTextures('default'), Starling.current.nativeStage.frameRate);

    starlingMc.loop = false;
    starlingMc.addEventListener(Event.COMPLETE, function(){ trace('Animation complete') });

    Starling.juggler.add(starlingMc);

    addChild(starlingMc);

    // With Assetfy and AssetfyMovieClip
    var mc:MyFlashMovieClip         = new MyFlashMovieClip;
    var assetfyMc:AssetfyMovieClip  = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);
    assetfyMc.play('default').onComplete(function():void { trace('Animation complete!'); });

    addChild(assetfyMc);
```
