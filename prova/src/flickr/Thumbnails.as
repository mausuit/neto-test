package flickr
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	import flickr.events.ThumbnailEvent;
	
	import interfaces.iSection;
	
	public class Thumbnails extends Sprite implements iSection
	{
		// ---------------------------------------------------
		// VARIABLES
		// ---------------------------------------------------
		private var _thumbsSize			:int = 75;
		private var _thumbsSpace		:int = 5;
		private var _columns			:int = 8;
		private var _rows				:int = 3;
		private var _backgroundWidth	:int;
		private var _backgroundHeight	:int;
		private var _thumbsLoaded		:int;
		
		
		// ---------------------------------------------------
		// INSTANCES
		// ---------------------------------------------------
		private var _controller	:FlickrController;
		private var _background	:Shape;
		
		// [key][value] --> [Loader][ThumbData]
		private var _thumbsList	:Dictionary;
		private var _spritesList:Array;
		
		
		public function Thumbnails(controller:FlickrController)
		{
			_controller = controller;
			setup();
		}
		
		
		
		private function setup():void
		{
			Security.allowDomain("*", "api.flickr.com");
			
			_spritesList		= [];
			_thumbsList			= new Dictionary();
			
			_controller.addEventListener(FlickrController.ON_LOAD_ERROR, searchError);
			_controller.addEventListener(FlickrController.ON_LOAD_SUCCESS, loadThumbs);
			
			_backgroundWidth 	= (_thumbsSize + _thumbsSpace) * _columns + _thumbsSpace;
			_backgroundHeight	= (_thumbsSize + _thumbsSpace) * _rows + _thumbsSpace;
			
			_background 		= new Shape();
			_background.alpha 	= 0;
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(0, 0, _backgroundWidth, 1);
			
			_background.x = _backgroundWidth / -2;
			
			addChild(_background);
		}
			
		
		
		public function open():void
		{
			visible = true;
			TweenLite.to(_background, 1, {height:_backgroundHeight, alpha:1, ease:Quint.easeInOut, onComplete:initSearch});
		}
		private function initSearch():void
		{
			_controller.search("flowers", _columns * _rows);
		}
		private function searchError(e:Event):void
		{
			ExternalInterface.call("alert", "searchError");
		}
		private function loadThumbs(e:Event):void
		{
			_thumbsLoaded = 0;
			
			var thumbLoader	:Loader;
			var thumbData	:ThumbData;
			var thumbID		:int = 0;
			var thumbURL	:String;
			
			for(var a:int = 0; a < _columns; a++)
			{
				for(var b:int = 0; b < _rows; b++)
				{
					thumbLoader 		= new Loader();
					thumbLoader.alpha	= 0;
					thumbLoader.x 		= ((_thumbsSize + _thumbsSpace) * a + _thumbsSpace) - (_backgroundWidth / 2);
					thumbLoader.y 		= (_thumbsSize + _thumbsSpace) * b + _thumbsSpace;
					addChild(thumbLoader);
					
					thumbData	= new ThumbData(_controller.farm(thumbID),_controller.server(thumbID), _controller.id(thumbID), _controller.secret(thumbID));
					
					thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 			onThumbLoaded);
					thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	onThumbError);
					
					thumbURL = "http://farm" + thumbData.farm + ".static.flickr.com/" + thumbData.server + "/" + thumbData.id + "_" + thumbData.secret + "_s.jpg";
					thumbLoader.load(new URLRequest(thumbURL));
					
					_thumbsList[thumbLoader] = thumbData;
					thumbID++;
				}
			}
		}
		private function onThumbLoaded(e:Event):void
		{
			_thumbsLoaded++;
			
			if(_thumbsLoaded == _columns * _rows)
			{
				onOpenFinish();
			}
			
			var loader:Loader		= e.target.loader;
			var thumb:Bitmap 		= e.target.content as Bitmap;
			var thumbHolder:MovieClip	= new MovieClip();
				thumbHolder.loader		= loader;
				thumbHolder.alpha		= 0;
				thumbHolder.x			= loader.x;
				thumbHolder.y			= loader.y;
				thumbHolder.addChild(thumb);
				
				thumbHolder.buttonMode = true;
				thumbHolder.addEventListener(MouseEvent.ROLL_OVER, 	thumbsHandlers);
				thumbHolder.addEventListener(MouseEvent.ROLL_OUT, 	thumbsHandlers);
				thumbHolder.addEventListener(MouseEvent.CLICK, 		thumbsHandlers);
			
			_spritesList.push(thumbHolder);
			addChild(thumbHolder);
			TweenLite.to(thumbHolder, 0.5, {alpha:1});
		}
		private function thumbsHandlers(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
					target.y -= 2;
					break;
				
				case MouseEvent.ROLL_OUT:
					target.y += 2;
					break;
				
				case MouseEvent.CLICK:
					dispatchEvent(new ThumbnailEvent(ThumbnailEvent.OPEN_PHOTO, _thumbsList[target.loader]));
					break;
			}
		}
		private function onThumbError(e:IOErrorEvent):void
		{
			
		}
		private function onOpenFinish():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		
		
		public function close():void
		{
			// ExternalInterface.call("alert", "Thumbnails :: close : " + _spritesList.length);
			for(var a:int = 0; a < _spritesList.length; a++)
			{
				TweenLite.to(_spritesList[a], 0.5, {alpha:0, delay:0.05 * a});
			}
			TweenLite.to(_background, 1, {height:1, alpha:0, delay:1, ease:Quint.easeInOut, onComplete:onCloseFinish});
		}
		private function onCloseFinish():void
		{
			visible = false;
			
			_thumbsList 	= new Dictionary();
			_spritesList	= [];
			
			for(var a:int = 0; a < _spritesList.length; a++)
			{
				removeChild(_spritesList[a]);
			}
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}
}