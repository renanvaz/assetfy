package assetfy.utils {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;

    public class Color {

        public function Color() {}

        public static function multiply(bmInput:Bitmap, color:uint = 0x990099):Bitmap {
            var bmd:BitmapData  = new BitmapData(bmInput.width, bmInput.height, true, 0x00000000),
                colorRGB:Object = {
                    r: ((color & 0xFF0000) >> 16),
                    g: ((color & 0x00FF00) >> 8),
                    b: ((color & 0x0000FF))
                };

            bmd.draw(bmInput.bitmapData, null, new ColorTransform(colorRGB.r / 255, colorRGB.g / 255, colorRGB.b / 255));
            return new Bitmap(bmd);
        }


        // Not implemented
        public static function tint(bmInput:Bitmap, color:uint = 0x990099):Bitmap {
			return null;
        }

    }

}
