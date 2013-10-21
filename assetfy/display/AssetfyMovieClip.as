package assetfy.display {

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class AssetfyMovieClip extends Sprite implements IAnimatable {

        private var _data:Object            = {};
        private var _totalPassedTime:Number = 0;
        private var _stopped:Boolean        = true;
        private var _loop:Boolean           = false;
        private var _mode:String            = '';
        private var _view:Image;
		private var _onComplete:Function;

        public var fps:int = Starling.current.nativeStage.frameRate;
        public var index:int = 0;
        public var animation:String = '';


        public function AssetfyMovieClip (frames:Vector.<Object>) {
            var name:String;
            for (var i:int = 0; i < frames.length; i++) {
                name = frames[i].label ? frames[i].label : 'default';

                if(!this._data[name]){ this._data[name] = new Vector.<Object>(); }

                frames[i].image = Image.fromBitmap(frames[i].bm, false, Starling.contentScaleFactor);
                delete frames[i].bm;

                this._data[name].push(i);
            }

            this._data.frames = frames;
        }

        public function loop (name:String):void {
            this.animation = name;
            this.index = 0;

            this.goTo(this.animation, this.index);

            this._loop = true;

            this.resume();
        }

        public function play (name:String, onComplete:Function = null):void {
            this.animation = name;
            this.index = 0;

            this.goTo(this.animation, this.index);

            this._loop = false;
			this._onComplete = onComplete;

            this.resume();
        }

        public function stop ():void {
            this.index = 0;
            this.pause();
        }

        public function pause ():void {
            Starling.juggler.remove(this);
        }

        public function resume ():void {
            Starling.juggler.add(this);
        }

        private function goTo (name:String, index:int = 0):void {
            this.animation = name;
            this.index = index;

            if(this._view) { this.removeChild(this._view); }

            var current:Object = this._data.frames[this._data[this.animation][this.index]];
            this._view = current.image;

            this._view.x = current.coordinates.pivotX;
            this._view.y = current.coordinates.pivotY;

            this.addChild(this._view);
        }

        public function advanceTime(passedTime:Number):void {
            this._totalPassedTime += passedTime;

            if(this._totalPassedTime > (1 / this.fps)){
                this._totalPassedTime = 0;

                this.index++;

                if(this.index < this._data[this.animation].length){
                    this.goTo(this.animation, this.index);
                }else if(this._loop){
                    this.index = 0;
                }else {
                    this.stop();

					if (this._onComplete) { this._onComplete.call(this); }
                }
            }else{
                return;
            }

            // Verify what is the carryOverTime in Starling Tween class
        }
    }

}
