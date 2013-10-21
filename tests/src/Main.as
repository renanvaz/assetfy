package
{

	import assetfy.Assetfy;
	import assetfy.classes.AssetfyMovieClip;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Main extends Sprite
	{
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function onAdded():void {

			var mc:Test = new Test;
			var m:AssetfyMovieClip = Assetfy.me(mc, Assetfy.types.ASSETFY_MOVIECLIP);
			m.play('default', function():void { trace('Terminou', this.fps); });

			m.x = m.y = 150;

			addChild(m);

		}
	}
}
