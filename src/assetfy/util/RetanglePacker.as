/**
 * Based on this project: https://github.com/jakesgordon/bin-packing
 */

package assetfy.util {

    public class RetanglePacker {
        private var canvas:Object = {x: 0, y: 0, w: 0, h: 0};

        public static var sort:Object = {
            w       : function (a:*, b:*):Number { return b.w - a.w; },
            h       : function (a:*, b:*):Number { return b.h - a.h; },
            a       : function (a:*, b:*):Number { return b.area - a.area; },
            max     : function (a:*, b:*):Number { return Math.max(b.w, b.h) - Math.max(a.w, a.h); },
            min     : function (a:*, b:*):Number { return Math.min(b.w, b.h) - Math.min(a.w, a.h); },

            height  : function (a:*, b:*):Number { return RetanglePacker.sort.msort(a, b, ['h', 'w']);               },
            width   : function (a:*, b:*):Number { return RetanglePacker.sort.msort(a, b, ['w', 'h']);               },
            area    : function (a:*, b:*):Number { return RetanglePacker.sort.msort(a, b, ['a', 'h', 'w']);          },
            maxside : function (a:*, b:*):Number { return RetanglePacker.sort.msort(a, b, ['max', 'min', 'h', 'w']); },

            msort: function(a:*, b:*, criteria:Array):Number { /* sort by multiple criteria */
			var diff:Number, n:int;
                for (n = 0 ; n < criteria.length ; n++) {
                    diff = RetanglePacker.sort[criteria[n]](a,b);
                    if (diff != 0)
                    return diff;
                }
                return 0;
            }
        }

        public function RetanglePacker (w:int, h:int) {
            this.canvas.w = w;
            this.canvas.h = h;
        }

        public function fit (blocks:Vector.<Object>):void {
            var n:int, node:Object, block:Object;
            for (n = 0; n < blocks.length; n++) {
                block = blocks[n];
				node = this.findNode(this.canvas, block.w, block.h)
                if (node){
                    block.fit = this.splitNode(node, block.w, block.h);
                }
            }
        }

        public function  findNode(canvas:Object, w:Number, h:Number):Object {
            if (canvas.used) {
                return this.findNode(canvas.right, w, h) || this.findNode(canvas.down, w, h);
            } else if ((w <= canvas.w) && (h <= canvas.h)) {
                return canvas;
            } else {
                return null;
            }
        }

        public function splitNode(node:Object, w:Number, h:Number):Object {
            node.used = true;
            node.down  = { x: node.x,     y: node.y + h, w: node.w,     h: node.h - h };
            node.right = { x: node.x + w, y: node.y,     w: node.w - w, h: h          };
            return node;
        }

    }
}
