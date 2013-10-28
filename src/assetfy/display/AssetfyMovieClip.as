package assetfy.display {
    import flash.geom.Rectangle;
	import flash.utils.Dictionary;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.textures.Texture;
    import starling.display.Image;

    public class AssetfyMovieClip extends Image implements IAnimatable {

        private static var _data:Dictionary = new Dictionary;
        private var _totalPassedTime:Number = 0;
        private var _stopped:Boolean        = true;
        private var _loop:Boolean           = false;
        private var _mode:String            = '';
        private var _fps:int                = 0;
        private var _timeLimit:Number       = 0;
        private var _id:String;
        private var _view:Image;
		private var _onComplete:Function;

        public var index:int = 0;
        public var animation:String = '';

        public function get fps ():int {
            return this._fps;
        }

        public function set fps (v:int):void {
            this._fps = v;
            this._timeLimit = (1 / this._fps);
        }

        public function AssetfyMovieClip (frames:*, fps:int = 0) {
            if(typeof frames === 'string'){
                this._id = frames;
                this.fps = fps;
            }else{
                var textures:Vector.<Texture> = new Vector.<Texture>;
                var t:Texture;
                var frame:Rectangle;
                var region:Rectangle;
                var i:int;
                var maxW:Number = 0, maxH:Number = 0;

                this._id = new Date().getTime().toString();
                this.fps = fps > 0 ? fps : Starling.current.nativeStage.frameRate;

                AssetfyMovieClip._data[this._id] = new Dictionary;

                for (i = 0; i < frames.length; i++) {
                    maxW = Math.max(maxW, frames[i].bm.width);
                    maxH = Math.max(maxH, frames[i].bm.height);
                }

                var name:String;
                for (i = 0; i < frames.length; i++) {
                    name = frames[i].label ? frames[i].label : 'default';

                    if(!AssetfyMovieClip._data[this._id][name]){ AssetfyMovieClip._data[this._id][name] = new Vector.<int>; }

                    frame   = new Rectangle(0, 0, frames[i].bm.width, frames[i].bm.height);
                    region  = new Rectangle(-frames[i].coordinates.pivotX, -frames[i].coordinates.pivotY, maxW, maxH);
                    t       = Texture.fromBitmap(frames[i].bm, false, false, Starling.contentScaleFactor);

                    textures.push(Texture.fromTexture(t, frame, region));

                    AssetfyMovieClip._data[this._id][name].push(i);
                }

                AssetfyMovieClip._data[this._id]['frames'] = textures.concat();
            }

			super( AssetfyMovieClip._data[this._id]['frames'][0]);
        }

        public function clone ():AssetfyMovieClip {
            return new AssetfyMovieClip(this._id, this.fps);
        }

        public function loop (name:String, fps:int = 0):void {
			this._loop = true;
            this.animation = name;
            this.index = 0;

			if (fps > 0) {
				this.fps = fps;
			}

            this.goTo(this.animation, this.index);

            this.resume();
        }

        public function play (name:String, fps:int = 0):AssetfyMovieClip {
			this._loop = false;
            this.animation = name;
            this.index = 0;

			if (fps > 0) {
				this.fps = fps;
			}

            this.goTo(this.animation, this.index);

            this.resume();

			return this;
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

        public function onComplete (fn:Function):void {
            this._onComplete = fn;
        }

        private function goTo (name:String, index:int = 0):void {
            this.animation = name;
            this.index = index;

			texture = AssetfyMovieClip._data[this._id]['frames'][AssetfyMovieClip._data[this._id][this.animation][this.index]];
        }

        public function advanceTime(passedTime:Number):void {
            this._totalPassedTime += passedTime;

            var diffTime:Number = this._totalPassedTime - this._timeLimit;

            if (diffTime >= 0) {
                this._totalPassedTime = 0;

                this.index++;

                if(this.index < AssetfyMovieClip._data[this._id][this.animation].length){
                    this.goTo(this.animation, this.index);
                }else if(this._loop){
                    this.index = 0;
                }else {
                    this.stop();

					if (this._onComplete) { this._onComplete.call(this); this._onComplete = null; }
                }

                if (diffTime > 0) {
                    this.advanceTime(diffTime);
                }
            } else {
                return;
            }
        }
    }

}
