package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width="320",height="480",frameRate="30",backgroundColor="#FFcccc")]
	public class AssetfyTest extends Sprite
	{
		public var _starling:Starling;
		
		public function AssetfyTest()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this._starling = new Starling(Main, this.stage);
			this._starling.enableErrorChecking = false;
			this._starling.start();
		}
	}
}