package flickr
{
	import flash.display.Bitmap;

	public class ThumbData
	{
		private var _farm	:String;
		private var _id		:String;
		private var _secret	:String;
		private var _server	:String;
		
		private var _img	:Bitmap;
		
		public function ThumbData(farm:String, server:String, id:String, secret:String)
		{
			_farm	= farm;
			_server	= server;
			_id		= id;
			_secret = secret;
		}
		
		public function set img(v:Bitmap):void	{ _img = v; }
		
		public function get farm():String 		{ return _farm; }
		public function get server():String 	{ return _server; }
		public function get id():String 		{ return _id; }
		public function get secret():String 	{ return _secret; }
	}
}