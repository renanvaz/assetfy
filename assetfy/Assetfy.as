package assetfy {
	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.textures.TextureAtlas;
    import starling.textures.Texture;

    public class Assetfy {
        public static const types:Object = {
            BITMAP:             'bitmap',
            TEXTURE:            'texture',
            IMAGE:              'image',
            TEXTURE_ATLAS:      'texture_atlas',
            ASSETFY_MOVIECLIP:  'assetfy_movieclip'
        }

        public function Assetfy() {}

        public static function content ():Object {
            return {};
        }

        public static function me (container:MovieClip, type:String = 'bitmap'):* {
            switch (type) {
                case Assetfy.types.ASSETFY_MOVIECLIP:
                    return false;
                break;
                case Assetfy.types.TEXTURE_ATLAS:
                    var atlas:String = '';
                    /*'<TextureAtlas>
                        <SubTexture name="flight_00" x="0"   y="0" width="50" height="50" />
                        <SubTexture name="flight_01" x="50"  y="0" width="50" height="50" />
                        <SubTexture name="flight_02" x="100" y="0" width="50" height="50" />
                        <SubTexture name="flight_03" x="150" y="0" width="50" height="50" />
                    </TextureAtlas>';*/

                    //var xml:XML = XML(atlas);
                    return Assetfy.allFramesToBitmap(container);
                break;
                case Assetfy.types.IMAGE:
                    return Image.fromBitmap(Assetfy.toBitmap(container), false, Starling.contentScaleFactor);
                break;
                case Assetfy.types.TEXTURE:
                    return Texture.fromBitmap(Assetfy.toBitmap(container), false, false, Starling.contentScaleFactor);
                break;
                default: // Default is Assetfy.types.BITMAP
                    return Assetfy.toBitmap(container);
                break;
            }
        }

        /**
         * Convert all frames into a single bitmap
         * @param  container: MovieClip
         * @return  {bm:Bitmap, coordinates:Object }
         *                      coordinates {x: 0, y: 0, width: 0, height: 0}
         */
        private static function allFramesToBitmap (container:MovieClip):Object {
            var c:Vector.<Object>   = new Vector.<Object>(),
                limitX:int          = 7,
				_w:Number			= 0,
				_h:Number			= 0,
				w:Number			= 0,
				h:Number			= 0,
                mc:MovieClip        = new MovieClip,
                bm:Bitmap;
			
			// Issue: create a mosaic logic
			
            for (var i:int = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);
				
				_w = container.width;
				_h = container.height;
				
				if(container.hasOwnProperty('crop')){
					_w = container.crop.width;
					_h = container.crop.height;
				}
				
                w = Math.max(_w, w);
				h = Math.max(_h, h);
            }

            for (i = 0; i < container.totalFrames; i++) {
                container.gotoAndStop(i + 1);
                bm = Assetfy.toBitmap(container);

                bm.x = ((i%limitX) * w);
                bm.y = (Math.floor(i/limitX) * h);
                mc.addChild(bm);

                c.push({x: bm.x, y: bm.y, width: bm.width, height: bm.height});
            }
			
            bm = Assetfy.toBitmap(mc);

            return {bm: bm, coordinates: c};
        }

        private static function toBitmap (container:MovieClip):Bitmap {
            var w:Number = container.width,
                h:Number = container.height,
                s:Sprite =  new Sprite,
                bm:Bitmap,
                bmd:BitmapData;

            if(container.hasOwnProperty('crop')){
                w = container.crop.width;
                h = container.crop.height;
            }
			
			container.x = container.y = 0;

            s.addChild(container);

            bmd = new BitmapData(w, h, false, 0x00000000);
            bmd.draw(s);

            bm = new Bitmap(bmd);

            return bm;
        }

    }

}
