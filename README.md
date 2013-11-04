# Assetfy for [Starling Framework](https://github.com/PrimaryFeather/Starling-Framework)
Assetfy is a open source library that converts flash MovieClip into Starling object formats.
You can do your animations with Flash Professional IDE and exports SWF or a SWC file to use in your Starling project.

**Why should i convert a Flash MovieClip instead of using the standard workflow of Starling?**
- Flash MovieClip can be drawn with vectors. Resize friendly!
- Flash MovieClip can contain action script in their frames. You can manipulate TextFields, Sprites and sub MovieClip animations of your MovieClip.
- Flash MovieClip can contain effects, filters and color corrections. In the end it will become drawned into a single Bitmap.
- You only need to change your MovieClip animation and export it again... Is not necessary to generate SpriteSheet Bitmap and XML to import in Starling.

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

- Accept filters.
- Accept color effects.
- SpriteSheets is generated with a retangle paking algorithm.
- Assetfy has a self implementation of a MovieClip Class API.
- Simple API usage.

You can convert the MovieClip to any formats:

```actionscript
Bitmap              (flash.dysplay.Bitmap)
Texture             (starling.textures.Texture)
Image               (starling.dysplay.Image)
TextureAtlas        (starling.textures.TextureAtlas)
AssetfyMovieClip    (assetfy.display.AssetfyMovieClip)
```

**Assetfy is helpful for automate spritesheets for character animations and flatten layout components. Not is useful for complex animations like "history video".**

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
Convert the current object to one of the output formats.

```actionscript
var mc:MyFlashMovieClip = new MyFlashMovieClip;

// Converts all the frames to a Assetfy AssetfyMovieClip (Best performance in a simple and usefull API)
var assetfyMc:AssetfyMovieClip = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);

// Converts all the frames to a Starling TextureAtlas (Sprite Texture and XML coordinates)
var ta:TextureAtlas = Assetfy.me(mc, Assetfy.types.TEXTURE_ATLAS);

// Converts the current frame to a Starling Image
var Image:Image = Assetfy.me(mc, Assetfy.types.IMAGE);

// Converts the current frame to a Starling Texture
var t:Texture = Assetfy.me(mc, Assetfy.types.TEXTURE);

// Converts the current frame to a Flash Bitmap
var bm:Bitmap = Assetfy.me(mc, Assetfy.types.BITMAP);
```

### The Assetfy.childs method
Convert all the childs of the current object to one of the output formats.
Each MovieClip in linkage should implement a class that extends one of the options of assetfy.type package.

    // More documentation is comming...

### The AssetfyMovieClip object (minimalist API)
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

// If you have various equal MovieClips, use the "clone" method, its solve a lot of memory and performance is much better
var assetfyMcBase:AssetfyMovieClip,
    assetfyMc:AssetfyMovieClip;

assetfyMcBase = Assetfy.me(mc, Assetfy.type.ASSETFY_MOVIECLIP);
for (var i = 0; i < 40; i++){
    assetfyMc = assetfyMcBase.clone();
    assetfyMc.loop('default');
    addChild(m);
}
```

### Why AssetfyMovieClip is not simply called MovieClip?
AssetfyMovieClip has a personal API, so there is no risk of confusion with the Starling MovieClip instance and API.

## How to prepare the flash MovieClip to be converted by Assetfy?
Assetfy uses the label property to assign TextureAtlas and AssetfyMovieClip animations, if the label property is not set, Assetfy will use the name as "default".


## Starling normal workflow comparison

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


### Imagine to play 2 animations in sequence...


# Next steps

- Create a API for sounds in AssetfyMovieClip.
- Add Bitmap font support.
- ...

**Send yours ideas in the issues list.**
