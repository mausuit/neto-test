package flickr
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	public class FlickrController extends EventDispatcher
	{
		// ------------------------------------------------
		// CONTANTS
		// ------------------------------------------------
		public static const ON_LOAD_SUCCESS	:String = "onLoadSuccess";
		public static const ON_LOAD_ERROR	:String = "onLoadError";
		
		
		// ------------------------------------------------
		// INSTANCES
		// ------------------------------------------------
		private var _model:FlickrModel;
		
		
		public function FlickrController(model:FlickrModel)
		{
			_model = model;
			setup();
		}
		
		
		// ------------------------------------------------
		// METHODS
		// ------------------------------------------------
		private function setup():void
		{
			_model.addEventListener(FlickrModel.ON_LOAD_ERROR, 		modelHandlers);
			_model.addEventListener(FlickrModel.ON_LOAD_SUCCESS, 	modelHandlers);
		}
		
		
		
		private function modelHandlers(e:Event):void
		{
			switch(e.type)
			{
				case FlickrModel.ON_LOAD_ERROR:
					dispatchEvent(new Event(ON_LOAD_ERROR));
					break;
				
				case FlickrModel.ON_LOAD_SUCCESS:
					dispatchEvent(new Event(ON_LOAD_SUCCESS));
					break;
			}
		}
		
		
		
		public function search(tag:String, per_page:int = 5, page:int = 1):void
		{
			_model.search(tag, per_page, page);
		}
		
		
		
		public function farm(id:int = 0):String
		{
			var farmID:String = "";
			
			if(id <= _model.data.photos.photo.length() - 1)
			{
				farmID = _model.data.photos.photo[id].@farm;
			}
			else
			{
				trace("FlickrController :: farm :: Não existe a imagem [" + id + "]");
			}
			
			return farmID;
		}
		
		
		
		public function server(id:int = 0):String
		{
			var serverID:String = "";
			
			if(id <= _model.data.photos.photo.length() - 1)
			{
				serverID = _model.data.photos.photo[id].@server;
			}
			else
			{
				trace("FlickrController :: server :: Não existe a imagem [" + id + "]");
			}
			
			return serverID;
		}
		
		
		
		public function id(id:int):String
		{
			var imageID:String = "";
			
			if(id <= _model.data.photos.photo.length() - 1)
			{
				imageID = _model.data.photos.photo[id].@id;
			}
			else
			{
				trace("FlickrController :: id :: Não existe a imagem [" + id + "]");
			}
			
			return imageID;
		}
		
		
		
		public function secret(id:int):String
		{
			var secretID:String = "";
			
			if(id <= _model.data.photos.photo.length() - 1)
			{
				secretID = _model.data.photos.photo[id].@secret;
			}
			else
			{
				trace("FlickrController :: secret :: Não existe a imagem [" + id + "]");
			}
			
			return secretID;
		}
		
		public function data():XML
		{
			return _model.data;
		}
	}
}