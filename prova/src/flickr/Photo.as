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
	
	import interfaces.iSection;
	
	public class Photo extends Sprite implements iSection
	{
		private var _loader			:Loader;
		private var _request		:URLRequest;
		private var _url			:String;
		private var _background		:Shape;
		private var _borderSize		:int = 5;
		private var _loaderMc		:MovieClip;
		private var _enlargedImage	:Bitmap;
		
		
		public function Photo()
		{
			setup();
		}
		
		
		
		private function setup():void
		{
			_loader		= new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			
			_request	= new URLRequest();
			_loaderMc	= new LoaderMc();
			
			_background	= new Shape();
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(0, 0, 1, 1);
		}
		
		
		
		public function load(data:ThumbData):void
		{
			_request.url = "http://farm" + data.farm + ".static.flickr.com/" + data.server + "/" + data.id + "_" + data.secret + "_z.jpg";
		}
		
		
		
		public function open():void
		{
			visible = true;
			
			_loaderMc.y = 200;
			_loaderMc.gotoAndPlay("loop");
			addChild(_loaderMc);
			
			_loader.load(_request);
		}
		private function onOpenFinish():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		
		
		public function close():void
		{
			TweenLite.to(_enlargedImage, 0.5, {alpha:0});
			TweenLite.to(_background, 0.5, {delay:0.5, alpha:0, height:1, ease:Quint.easeOut, onComplete:onCloseFinish});
		}
		private function onCloseFinish():void
		{
			visible = false;
			removeChild(_enlargedImage);
			removeChild(_background);
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		
		private function onImageLoaded(e:Event):void
		{
			_loaderMc.gotoAndStop(1);
			removeChild(_loaderMc);
			
			_enlargedImage 			= e.target.content;
			_enlargedImage.alpha  	= 0;
				
			var finalBGWidth:int	= _enlargedImage.width + _borderSize * 2;;
			var finalBGHeight:int	= _enlargedImage.height + _borderSize * 2;;
			
			_background.width	= finalBGWidth;
			_background.height	= 1;
			
			_background.x = finalBGWidth / -2;
			addChild(_background);
			
			_enlargedImage.x = _background.x + _borderSize;
			_enlargedImage.y = _borderSize;
			addChild(_enlargedImage);
			
			TweenLite.to(_background, 0.5, {alpha:1, height:finalBGHeight, ease:Quint.easeOut});
			TweenLite.to(_enlargedImage, 0.5, {alpha:1, delay:0.5});
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, mouseHandlers);
		}
		
		private function mouseHandlers(e:MouseEvent):void
		{
			buttonMode = false;
			removeEventListener(MouseEvent.CLICK, mouseHandlers);
			close();
		}
		
		
		
		private function onImageError(e:IOErrorEvent):void
		{
			
		}
	}
}