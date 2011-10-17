package flickr.events
{
	import flash.events.Event;
	
	import flickr.ThumbData;
	
	public class ThumbnailEvent extends Event
	{
		// --------------------------------------------------------
		// CONSTANTS
		// --------------------------------------------------------
		public static const OPEN_PHOTO:String = "openPhoto";
		
		
		// --------------------------------------------------------
		// VARIABLES
		// --------------------------------------------------------
		private var _data:ThumbData;
		
		
		public function ThumbnailEvent(type:String, data:ThumbData)
		{
			_data = data;
			super(type, false, false);
		}
		
		public function get data():ThumbData { return _data; }
	}
}