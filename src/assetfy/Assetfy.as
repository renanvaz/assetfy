package assetfy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import assetfy.display.AssetfyMovieClip;
	import assetfy.util.StringHelper;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

    public class Assetfy {
        public static const type:Object = {
            BITMAP:             'bitmap',
            TEXTURE:            'texture',
            IMAGE:              'image',
            TEXTURE_ATLAS:      'texture_atlas',
            ASSETFY_MOVIECLIP:  'assetfy_movieclip'
        }

        public static var padding:int = 6;

        public function Assetfy() {}

        public static function childs (container:DisplayObjectContainer):Object {
            return {
                mcToConvert: ''
            };
        }

        public static function me (mc:MovieClip, type:String = 'bitmap'):* {
            switch (type) {
                case Assetfy.type.ASSETFY_MOVIECLIP:
                    return new AssetfyMovieClip(Assetfy.getArrayFrames(mc));
                break;
                case Assetfy.type.TEXTURE_ATLAS:
                    var map:Object = Assetfy.toSpriteSheet(mc),
                        xmlText:String = '';

                    for each(var i:Object in map.coordinates){
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

        private static function getArrayFrames (container:MovieClip):Vector.<Object> {
            var c:Vector.<Object> = new Vector.<Object>();

            for (var i:int = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);
                c.push(Assetfy.toBitmap(container));
            }

            return c;
        }

        /**
         * Convert all frames into a single bitmap
         * @param  container: MovieClip
         * @return  {bm:Bitmap, coordinates:Object }
         *                      coordinates {x: 0, y: 0, width: 0, height: 0}
         */
        private static function toSpriteSheet (container:MovieClip):Object {
            var c:Vector.<Object>   = new Vector.<Object>(),
                limitX:int          = Math.ceil(Math.sqrt(container.totalFrames)),
                x:Number            = 0,
                y:Number            = 0,
                wMax:Number         = 0,
                hMax:Number         = 0,
                wMaxFrame:Number    = 0,
                hMaxFrame:Number    = 0,
                yIndex:int          = 0,
                rowHMax:int         = 0,
                mc:MovieClip        = new MovieClip,
                data:Object,
                bm:Bitmap,
                name:String;

            // Feature: create a mosaic logic (retalgle packing)

            for (var i:int = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);

                wMax = Math.ceil(Math.max(container.width, wMax));
                hMax = Math.ceil(Math.max(container.height, hMax));
            }

            if(limitX * wMax > 2048){ limitX = Math.floor(2048 / wMax); }

            for (i = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);
                data = Assetfy.toBitmap(container);

                if(yIndex != Math.floor(i/limitX)){
                    yIndex = Math.floor(i/limitX);

                    x = 0;
                    y += rowHMax + Assetfy.padding;
                    rowHMax = 0;
                }

                bm = data.bm;
                bm.x = x;
                bm.y = y;
                mc.addChild(bm);

                x += bm.width + Assetfy.padding;
                rowHMax = Math.max(rowHMax, bm.height);

                c.push({name: data.name, x: bm.x, y: bm.y, width: bm.width, height: bm.height, frameX: -data.coordinates.pivotX, frameY: -data.coordinates.pivotY, frameWidth: wMax, frameHeight: hMax});
            }

            data = Assetfy.toBitmap(mc);

            return {bm: data.bm, coordinates: c};
        }

        private static function toBitmap (container:MovieClip):Object {
            var w:Number = Math.ceil(container.width),
                h:Number = Math.ceil(container.height),
                s:Sprite =  new Sprite,
                bm:Bitmap,
                bmd:BitmapData,
                rect:Rectangle,
                name:String;

			container.x = container.y = 0;

            s.addChild(container);

            rect = container.getRect(container);
            rect.x *= container.scaleX;
            rect.y *= container.scaleY;

            bmd = new BitmapData(w, h, true, 0x00000000);
            bmd.draw(s, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));

            bm = new Bitmap(bmd);
            bm.smoothing = true;

            name = StringHelper.padLeft(container.currentFrame.toString(), '0', 3);
            name = container.currentLabel ? container.currentLabel + '_' + name : 'default_' + name;

            return {bm: bm, name: name, frame: container.currentFrame, label: container.currentLabel, coordinates: {pivotX: rect.x, pivotY: rect.y}};
        }

    }

}
