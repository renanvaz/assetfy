package
{
	
	import assetfy.Assetfy;
	import assetfy.display.AssetfyMovieClip;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Image;
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
			var test:String = Assetfy.type.SPRITE_SHEET;
			var mc:EteTest = new EteTest;
			var container:containerTest = new containerTest;
			var mBase:*;
			var m:*;
			var i:int;
			mc.scaleX = mc.scaleY = .5;
			
			switch(test) {
				case 'childs':
					var convertedChilds:Object = Assetfy.childs(container);
					convertedChilds.image.x = 100;
					addChild(convertedChilds.image);
					addChild(convertedChilds.assetfyMovieClip);
					convertedChilds.assetfyMovieClip.loop('default', 24);
				break;
				case Assetfy.type.SPRITE_SHEET:
					var ss:Object = Assetfy.me(mc, Assetfy.type.SPRITE_SHEET);
					var img = Image.fromBitmap(ss.bm);
					img.width = 640; img.scaleY = img.scaleX;
					addChild(img);
				break;
				case Assetfy.type.ASSETFY_MOVIECLIP:
					/*for (var i = 0; i < 40; i++){
						m = Assetfy.me(mc, Assetfy.type.ASSETFY_MOVIECLIP);
						m.x = 30 * i;
						// m.play('default').onComplete(function():void { trace('Animation complete'); } );
						
						m.loop('default');
						addChild(m);
					}*/
					
					mBase = Assetfy.me(mc, Assetfy.type.ASSETFY_MOVIECLIP);
					for (i = 0; i < 5; i++){
						m = mBase.clone();
						m.x = 120 * i;
						m.y = 100;
						
						m.loop('fall');
						addChild(m);
					}
				break;
				case Assetfy.type.TEXTURE_ATLAS:
					for (i = 0; i < 40; i++){
						var t:TextureAtlas = Assetfy.me(mc, Assetfy.type.TEXTURE_ATLAS);
						m = new MovieClip(t.getTextures('fall'), Starling.current.nativeStage.frameRate);
						m.x = 30 * i;
						
						Starling.juggler.add(m);
						addChild(m);
					}
				break;
			}

		}
	}
}
