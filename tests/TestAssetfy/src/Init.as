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
	
	public class Init extends Sprite
	{
		public function Init()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function onAdded():void {
			var test:String = Assetfy.types.TEXTURE_ATLAS;
			var mc:MCExample = new MCExample;
			var m:*;
			
			switch(test) {
				case Assetfy.types.ASSETFY_MOVIECLIP:
					m = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);
					m.x = m.y = Starling.current.stage.stageWidth/2;
					addChild(m);
					
					// m.play('default').onComplete(function():void { trace('Terminou'); });
					m.loop('default');
				break;
				case Assetfy.types.TEXTURE_ATLAS:
					var t:TextureAtlas = Assetfy.me(mc, Assetfy.types.TEXTURE_ATLAS);
					m = new MovieClip(t.getTextures('default'), Starling.current.nativeStage.frameRate);
					m.x = m.y = Starling.current.stage.stageWidth/2;
					m.loop = false;
					
					m.addEventListener(Event.COMPLETE, function(){ trace('Animation complete') });
					
					Starling.juggler.add(m);
					addChild(m);
				break;
			}

		}
	}
}
