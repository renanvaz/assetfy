package
{
	
	import assetfy.Assetfy;
	import assetfy.display.AssetfyMovieClip;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.ExpoInOut;
	
	public class Init extends Sprite
	{
		public function Init()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function onAdded():void {
			var test:String = Assetfy.type.ASSETFY_MOVIECLIP;
			var mc:MCExample2 = new MCExample2;
			var mBase:*;
			var m:*;
			mc.scaleX = mc.scaleY = .3;
			
			switch(test) {
				case Assetfy.type.ASSETFY_MOVIECLIP:
					for (var i = 0; i < 40; i++){
						m = Assetfy.me(mc, Assetfy.type.ASSETFY_MOVIECLIP);
						m.x = 30 * i;
						// m.play('default').onComplete(function():void { trace('Animation complete'); } );
						
						// TweenMax.to(m, 1, {y: 300, delay: 1 * i, ease: ExpoInOut.ease, repeat:1, yoyo:true});
						m.loop('default');
						addChild(m);
					}
					
					/*
					mBase = Assetfy.me(mc, Assetfy.type.ASSETFY_MOVIECLIP);
					for (var i = 0; i < 40; i++){
						m = mBase.clone();
						m.x = 30 * i;
						// m.play('default').onComplete(function():void { trace('Animation complete'); } );
						
						// TweenMax.to(m, 1, {y: 300, delay: 1 * i, ease: ExpoInOut.ease, repeat:1, yoyo:true});
						m.loop('default');
						addChild(m);
					}
					*/
				break;

			case Assetfy.type.TEXTURE_ATLAS:
					for (var i = 0; i < 40; i++){
						var t:TextureAtlas = Assetfy.me(mc, Assetfy.type.TEXTURE_ATLAS);
						m = new MovieClip(t.getTextures('default'), Starling.current.nativeStage.frameRate);
						m.x = 30 * i;
						
						Starling.juggler.add(m);
						addChild(m);
					}
				break;
			}

		}
	}
}
