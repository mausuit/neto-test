package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import flickr.Flickr;
	
	import interfaces.iSection;
	
	import youtube.Youtube;
	
	[SWF(backgroundColor=0x000000, width=1000, height=750)]
	
	public class Rex extends Sprite
	{
		// ------------------------------------------------
		// VARIABLES
		// ------------------------------------------------
		private var _enabledNavigation:Boolean 	= true;
		
		
		// ------------------------------------------------
		// INSTANCES
		// ------------------------------------------------
		private var _youtube		:Youtube 	= new Youtube();
		private var _flickr			:Flickr		= new Flickr();
		private var _currentModule	:iSection;
		private var _selectedButton	:MovieClip;
		
		
		// ------------------------------------------------
		// GRAPHICS ELEMENTS
		// ------------------------------------------------
		private var _header		:Header 	= new Header();
		private var _background	:Background	= new Background();
		
		
		public function Rex()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP;
			setup();
		}
		
		
		// ------------------------------------------------
		// METHODS
		// ------------------------------------------------
		private function setup():void
		{
			_header.x = 500;
			_header.y = 25;
			
			_header.youtubeBtn.alpha 		= 0.7;
			_header.youtubeBtn.buttonMode 	= true;
			_header.youtubeBtn.addEventListener(MouseEvent.ROLL_OVER, mainMenuHandlers);
			_header.youtubeBtn.addEventListener(MouseEvent.ROLL_OUT, mainMenuHandlers);
			_header.youtubeBtn.addEventListener(MouseEvent.CLICK, mainMenuHandlers);
			
			_header.flickrBtn.alpha 		= 0.7;
			_header.flickrBtn.buttonMode 	= true;
			_header.flickrBtn.addEventListener(MouseEvent.ROLL_OVER, mainMenuHandlers);
			_header.flickrBtn.addEventListener(MouseEvent.ROLL_OUT, mainMenuHandlers);
			_header.flickrBtn.addEventListener(MouseEvent.CLICK, mainMenuHandlers);
			
			addChild(_background);
			addChild(_header);
			
			_youtube.x = 500;
			_youtube.y = 175;
			_youtube.addEventListener(Event.OPEN, 	sectionHandlers);
			_youtube.addEventListener(Event.CLOSE, 	sectionHandlers);
			addChild(_youtube);
			
			_flickr.x = 500;
			_flickr.y = 175;
			_flickr.addEventListener(Event.OPEN, 	sectionHandlers);
			_flickr.addEventListener(Event.CLOSE, 	sectionHandlers);
			addChild(_flickr);
		}
		
		
		
		private function sectionHandlers(e:Event):void
		{
			switch(e.type)
			{
				case Event.OPEN:
					// ExternalInterface.call("alert", "Rex :: sectionHandlers");
					_enabledNavigation = true;
					break;
				
				case Event.CLOSE:
					if(_currentModule == _flickr)
					{
						_currentModule = _youtube;
					}
					else
					{
						_currentModule = _flickr;
					}
					_currentModule.open();
					break;
			}
		}
		
		
		
		private function mainMenuHandlers(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
					if(target != _selectedButton)
					{
						TweenLite.to(target, 0.35, {scaleY:1.2, alpha:1, ease:Quint.easeOut});
					}
					break;
				
				case MouseEvent.ROLL_OUT:
					if(target != _selectedButton)
					{
						TweenLite.to(target, 0.35, {scaleY:1, alpha:0.7, ease:Quint.easeOut});
					}
					break;
				
				case MouseEvent.CLICK:
					if(!_enabledNavigation)
					{
						return;
					}
					
					if(target != _selectedButton)
					{
						_enabledNavigation = false;
						
						if(_selectedButton)
						{
							TweenLite.to(_selectedButton, 0.35, {scaleY:1, alpha:0.7, ease:Quint.easeOut});
						}
						_selectedButton = target;
						
						// caso nao tiver nenhum aberto abre direto. Senao manda sair o que estiver
						if(_currentModule == null)
						{
							if(_selectedButton == _header.youtubeBtn)
							{
								_currentModule = _youtube;
							}
							else
							{
								_currentModule = _flickr;
							}
								
							_currentModule.open();
						}
						else
						{
							_currentModule.close();
						}
					}
					break;
			}
		}
		
		
		
		private function onCurrentModuleClose():void
		{
			if(_currentModule == _youtube)
			{
				_currentModule = _flickr;
			}
			else
			{
				_currentModule = _youtube;
			}
		}
	}
}


