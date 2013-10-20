package  {
	
	import flash.display.MovieClip;
	import assetfy.Assetfy;
	import assetfy.utils.Color;
	
	public class Dev extends MovieClip {
		
		
		public function Dev() {
			var b = Assetfy.me(mcToConvert, Assetfy.types.TEXTURE_ATLAS);
			trace(JSON.stringify(b.coordinates));
			b = b.bm;
			//b = Color.multiply(b);
			b.x = 5;
			b.y = 5;
			
			var m:MovieClip = new MovieClip;

			addChild(b);
			
		}
	}
	
}
