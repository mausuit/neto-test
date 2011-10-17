package youtube
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import interfaces.iSection;
	
	public class Youtube extends Sprite implements iSection
	{
		private var _videoDisplay:VideoDisplay = new VideoDisplay();
		
		
		public function Youtube()
		{
			setup();
		}
		
		
		
		private function setup():void
		{
			_videoDisplay.addEventListener(Event.OPEN, modulesHandlers);
			_videoDisplay.addEventListener(Event.CLOSE, modulesHandlers);
			addChild(_videoDisplay);
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
					// dispara um evento avisando que terminou de fechar para abrir outro conteúdo
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
		
		
		
		public function open():void
		{
			//ExternalInterface.call("alert", "Youtube :: open");
			_videoDisplay.open();
		}
		
		
		
		public function close():void
		{
			_videoDisplay.close();
		}
		
	}
}