package assetfy.util {

    public class StringHelper {

        public function StringHelper () {}

		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
            var s:String = p_string;
            while (s.length < p_length) { s = p_padChar + s; }
            return s;
        }
    }
}
