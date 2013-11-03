package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import starling.utils.HAlign;
    import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Renan Vaz
	 */
	[SWF(width="640", height="960", frameRate="60", backgroundColor="#cccccc")]
	public class Main extends Sprite 
	{
		public var _starling:Starling;
		
		public function Main():void 
		{	
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			this._starling = new Starling(Init, this.stage);
			this._starling.enableErrorChecking = false;
			this._starling.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);
			this._starling.start();
		}
		
	}
	
}