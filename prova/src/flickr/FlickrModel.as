package flickr
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class FlickrModel extends EventDispatcher
	{
		// -------------------------------------------------------
		// CONSTANTES
		// -------------------------------------------------------
		public static const ON_LOAD_SUCCESS	:String = "onLoadSuccess";
		public static const ON_LOAD_ERROR	:String = "onLoadError";
		
		
		// -------------------------------------------------------
		// VARIABLES
		// -------------------------------------------------------
		private var _urlSearchMethod	:String = "http://api.flickr.com/services/rest/?method=flickr.photos.search"
		private var _appKey				:String = "1b7502757fe81ac8c0247dac5313810f";
		private var _defaultTag			:String = "beach";
		private var _defaultPerPage		:int 	= 1;
		private var _defaultPage		:int 	= 1;
		private var _loader				:URLLoader = new URLLoader();
		
		// XML - resposta da busca
		private var _data:XML;
		
		
		
		public function FlickrModel():void
		{
			
		}
		
		
		
		public function search(tags:String = "", per_page:int = 0, page:int = 0):void
		{
			var finalURL:String			= _urlSearchMethod + "&api_key=" + _appKey + "&tags=" + tags + "&per_page=" + per_page + "&page=" + page;
			var request	:URLRequest 	= new URLRequest(finalURL);
			
			_loader.addEventListener(Event.COMPLETE, onLoadSuccess);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(request);
		}
		
		
		
		private function onLoadSuccess(e:Event):void
		{
			_data = new XML(e.target.data);
			
			if (_data.@stat == "ok")
			{
				dispatchEvent(new Event(ON_LOAD_SUCCESS));
			}
			else
			{
				dispatchEvent(new Event(ON_LOAD_ERROR));
			}
		}
		
		
		
		private function onLoadError(e:IOErrorEvent):void 
		{
			dispatchEvent(new Event(ON_LOAD_ERROR));
		}
		
		
		
		public function get data():XML 
		{
			return _data;
		}
	}
}