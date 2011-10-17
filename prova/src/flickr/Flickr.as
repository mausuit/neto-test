package flickr
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import flickr.events.ThumbnailEvent;
	
	import interfaces.iSection;
	
	
	public class Flickr extends Sprite implements iSection
	{
		private var _thumbs		:Thumbnails;
		private var _photo		:Photo;
		private var _controller	:FlickrController;
		private var _model		:FlickrModel;
		
		// true = passar de thumbs para photo
		// false = disparar evento de closeFinish
		private var _switch			:Boolean;
		private var _currentModule	:iSection;
		
		
		public function Flickr()
		{
			setup();
		}
		
		
		
		private function setup():void
		{
			_model		= new FlickrModel();
			_controller	= new FlickrController(_model);
			_thumbs 	= new Thumbnails(_controller);
			_photo		= new Photo();
			
			_thumbs.addEventListener(Event.OPEN, modulesHandlers);
			_thumbs.addEventListener(Event.CLOSE, modulesHandlers);
			_thumbs.addEventListener(ThumbnailEvent.OPEN_PHOTO, openPhoto);
			
			_photo.addEventListener(Event.OPEN, modulesHandlers);
			_photo.addEventListener(Event.CLOSE, modulesHandlers);
			
			addChild(_thumbs);
			addChild(_photo);
		}
		
		
		
		private function modulesHandlers(e:Event):void
		{
			switch(e.type)
			{
				case Event.OPEN:
					// dispara um evento avisando que terminou de abrir para habilitar o menu
					dispatchEvent(new Event(Event.OPEN));
					break;
				
				case Event.CLOSE:
					if(_switch)
					{
						// abre o que estiver fechado
						if(_currentModule == _thumbs)
						{
							_currentModule = _photo;
						}
						else
						{
							_currentModule = _thumbs;
						}
						
						_currentModule.open();
					}
					else
					{
						// dispara um evento avisando que terminou de fechar para abrir outro conteúdo
						dispatchEvent(new Event(Event.CLOSE));
					}
					break;
			}
		}
		
		
		
		private function openPhoto(e:ThumbnailEvent):void
		{
			_currentModule.close();
			_photo.load(e.data);
		}
		
		
		public function open():void
		{
			_switch 		= true;
			_currentModule 	= _thumbs;
			_currentModule.open();
		}
		
		
		
		public function close():void
		{
			// ExternalInterface.call("alert", "Flickr :: close" + _currentModule);
			_switch = false;
			_currentModule.close();
		}
	}
}