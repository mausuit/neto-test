package youtube
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class VideoDisplay extends Sprite
	{
		// ---------------------------------------------------
		// VARIABLES
		// ---------------------------------------------------
		private var _videoWidth		:int = 640;
		private var _videoHeight	:int = 360;
		private var _borderSize		:int = 5;
		
		// ---------------------------------------------------
		// INSTANCES
		// ---------------------------------------------------
		private var _loader			:Loader;
		private var _background		:Shape;
		private var _player			:Object;
		private var _videoID		:String = "";
		
		
		public function VideoDisplay()
		{
			setup();
		}
		
		
		
		private function setup():void
		{
			Security.allowDomain("*");
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlayerInit);
			
			_background 		= new Shape();
			_background.alpha 	= 0;
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(0, 0, (_videoWidth + _borderSize * 2), 1);
			_background.x 		= (_videoWidth + _borderSize * 2) / -2;
			addChild(_background);
		}
		
		
		
		private function onPlayerInit(e:Event):void
		{
			addChild(_loader);
			_loader.content.addEventListener("onReady", onPlayerReady);
			_loader.content.addEventListener("onError", onPlayerError);
			_loader.content.x = _background.x + _borderSize;
			_loader.content.y = _borderSize;
		}
		private function onPlayerReady(e:Event):void
		{
			_player = _loader.content;
			_player.loadVideoById("QihgVolY_OA");
		}
		private function onPlayerError(event:Event):void
		{
			trace("Erro no carregamento do player");
		}

		
		
		
		public function open():void
		{
			TweenLite.to(_background, 1, {height:_videoHeight + _borderSize * 2, alpha:1, ease:Quint.easeInOut, onComplete:onOpenFinish});
		}
		private function onOpenFinish():void
		{
			_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			dispatchEvent(new Event(Event.OPEN));
		}
		
		
		
		public function close():void
		{
			_player.destroy();
			TweenLite.to(_player, 0.5, 		{alpha:0, ease:Quint.easeInOut});
			TweenLite.to(_background, 1, 	{delay:0.5, height:1, alpha:0, ease:Quint.easeInOut, onComplete:onCloseFinish});
		}
		private function onCloseFinish():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}