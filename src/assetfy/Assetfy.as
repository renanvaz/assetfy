package assetfy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
    import flash.utils.getQualifiedSuperclassName;

    import assetfy.display.AssetfyMovieClip;
    import assetfy.util.StringHelper;
    import assetfy.util.RetanglePacker;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

    public class Assetfy {
        public static const VERSSION:String = 'v1.2';

        public static const type:Object = {
            BITMAP:             'bitmap',
            TEXTURE:            'texture',
            IMAGE:              'image',
            TEXTURE_ATLAS:      'texture_atlas',
            ASSETFY_MOVIECLIP:  'assetfy_movieclip'
        }

        public function Assetfy() {}

        public static function childs (container:DisplayObjectContainer):Object {
            var returnData:Object = {};
            var child:*;

            for(var i:int = 0; i < container.numChildren; i++){
                child = container.getChildAt(i);

                switch(getQualifiedSuperclassName(child)){
                    case 'assetfy.type::Bitmap':
                        returnData[child.name] = Assetfy.me(child, Assetfy.type.BITMAP);
                    break;
                    case 'assetfy.type::Texture':
                        returnData[child.name] = Assetfy.me(child, Assetfy.type.TEXTURE);
                    break;
                    case 'assetfy.type::Image':
                        returnData[child.name] = Assetfy.me(child, Assetfy.type.IMAGE);
                    break;
                    case 'assetfy.type::TextureAtlas':
                        returnData[child.name] = Assetfy.me(child, Assetfy.type.TEXTURE_ATLAS);
                    break;
                    case 'assetfy.type::AssetfyMovieClip':
                        returnData[child.name] = Assetfy.me(child, Assetfy.type.ASSETFY_MOVIECLIP);
                    break;
                }
            }

            return returnData;
        }

        public static function me (mc:MovieClip, type:String = 'bitmap'):* {
            switch (type) {
                case Assetfy.type.ASSETFY_MOVIECLIP:
                    return new AssetfyMovieClip(Assetfy.toSpriteSheet(mc));
                break;
                case Assetfy.type.TEXTURE_ATLAS:
                    var map:Object = Assetfy.toSpriteSheet(mc),
                        xmlText:String = '',
                        i:Object;

                    for each(i in map.coordinates){
                        xmlText += '<SubTexture name="' + i.name + '" x="' + i.x +'" y="' + i.y + '" width="' + i.width + '" height="' + i.height + '" frameX="' + i.frameX + '" frameY="' + i.frameY + '" frameWidth="' + i.frameWidth + '" frameHeight="' + i.frameHeight + '" />';
                    }

                    xmlText = '<TextureAtlas>' + xmlText + '</TextureAtlas>';

                    return new TextureAtlas(Texture.fromBitmap(map.bm, false, false, Starling.contentScaleFactor), XML(xmlText));
                break;
                case Assetfy.type.IMAGE:
                    return Image.fromBitmap(Assetfy.toBitmap(mc).bm, false, Starling.contentScaleFactor);
                break;
                case Assetfy.type.TEXTURE:
                    return Texture.fromBitmap(Assetfy.toBitmap(mc).bm, false, false, Starling.contentScaleFactor);
                break;
                default: // Default is Assetfy.type.BITMAP
                    return Assetfy.toBitmap(mc).bm;
                break;
            }
        }

        /**
         * Convert all frames into a single bitmap
         * @param  container: MovieClip
         * @return  {bm:Bitmap, coordinates:Object }
         */
        private static function toSpriteSheet (container:MovieClip):Object {
            var coordinates:Vector.<Object> = new Vector.<Object>(),
                coordinate:Object       = {},
                wMax:Number             = 0,
                hMax:Number             = 0,
                mc:MovieClip            = new MovieClip,
                packer:RetanglePacker   = new RetanglePacker(2048, 2048),
                blocks:Vector.<Object>  = new Vector.<Object>,
                block:Object,
                data:Object,
                bm:Bitmap,
                i:int;

            for (i = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);
                data = Assetfy.toBitmap(container);

                blocks.push({frame: i, w: data.bm.width, h: data.bm.height, bm: data.bm, coordinates: {name: data.name, label: data.label, frameX: -data.coordinates.pivotX, frameY: -data.coordinates.pivotY}});

                wMax = Math.ceil(Math.max(data.bm.width, wMax));
                hMax = Math.ceil(Math.max(data.bm.height, hMax));

                coordinates.push({});
            }

            blocks.sort(RetanglePacker.sort.maxside);
            packer.fit(blocks);

            for (i = 0; i < container.totalFrames; i++) {
                block = blocks[i];
                if (block.fit) {
                    bm = block.bm;
                    bm.x = block.fit.x;
                    bm.y = block.fit.y;
                    mc.addChild(bm);

                    coordinate             = block.coordinates;
                    coordinate.x           = bm.x;
                    coordinate.y           = bm.y;
                    coordinate.width       = bm.width;
                    coordinate.height      = bm.height;
                    coordinate.frameWidth  = wMax;
                    coordinate.frameHeight = hMax;

                    coordinates[block.frame] = coordinate;
                }
            }

            data = Assetfy.toBitmap(mc);

            return {bm: data.bm, coordinates: coordinates};
        }

        private static function toBitmap (container:MovieClip):Object {
            var w:Number = Math.ceil(container.width),
                h:Number = Math.ceil(container.height),
                p:* = container.parent,
                s:Sprite =  new Sprite,
                bm:Bitmap,
                bmd:BitmapData,
                rect:Rectangle,
                name:String,
                label:String;

            container.x = container.y = 0;

            s.addChild(container);

            rect = container.getRect(container);
            rect.x *= container.scaleX;
            rect.y *= container.scaleY;

            bmd = new BitmapData(w, h, true, 0x00000000);
            bmd.draw(s, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));

            bm = new Bitmap(bmd);
            bm.smoothing = true;

            label = container.currentLabel ? container.currentLabel : 'default';
            name = label + '_' + StringHelper.padLeft(container.currentFrame.toString(), '0', 3);

            if(p){ p.addChild(container); }

            return {bm: bm, name: name, frame: container.currentFrame, label: label, coordinates: {pivotX: rect.x, pivotY: rect.y}};
        }

    }

}
