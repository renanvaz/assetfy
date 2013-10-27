package assetfy.util {
	import flash.display.Sprite;

    public class Masonry {
        private static var w:Number = 400;
        private static var h:Number = 0;
        private static var cols:Number = 0;
        private static var colsY:Array = [];
        private static var columnWidth:Number = 0;

        public function Masonry () {}

		public static function organize (childs:Vector.<Sprite>):void {
			Masonry.reset(childs);

            for each (var child in childs) {
                var colSpan = Math.ceil( child.width / Masonry.columnWidth );
                colSpan = Math.min( colSpan, Masonry.cols );

                if ( colSpan === 1 ) {
                    Masonry.position( child, Masonry.colsY );
                } else {
                    var groupCount = Masonry.cols + 1 - colSpan,
                        groupY = [],
                        groupColY,
                        i;

                    for ( i=0; i < groupCount; i++ ) {
                        groupColY = Masonry.colsY.slice( i, i+colSpan );
                        groupY[i] = Math.max.apply( Math, groupColY );
                    }

                    Masonry.position( child, groupY );
                }
            }
        }

        private static function reset (childs:Vector.<Sprite>) {
            var segments = Math.floor( Masonry.w / childs[0].width );
            segments = Math.max( segments, 1 );

            Masonry.cols = segments;
            Masonry.columnWidth = childs[0].width;

            var i = Masonry.cols;
            Masonry.colsY = [];
            while (i--) {
                Masonry.colsY.push(0);
            }
        }

        private static function position (child, setY) {
            // get the minimum Y value from the columns
            var minimumY = Math.min.apply( Math, setY ),
            shortCol = 0;

            // Find index of short column, the first from the left
            for (var i=0, len = setY.length; i < len; i++) {
                if ( setY[i] === minimumY ) {
                    shortCol = i;
                    break;
                }
            }

            // position the brick
            var x = Masonry.columnWidth * shortCol,
            y = minimumY;

            child.x = x;
			child.y = y;

            // apply setHeight to necessary columns
            var setHeight = minimumY + child.height,
            setSpan = Masonry.cols + 1 - len;
            for ( i=0; i < setSpan; i++ ) {
                Masonry.colsY[ shortCol + i ] = setHeight;
            }
        }

    }

}
