package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		static internal var SIZE:uint = 64;
		
		static internal var originalImage:OriginalImage;
		static internal var freqImage:FreqImage;
		static internal var pickFreq:PickFreq;
		static internal var newBitmapData:NewBitmapData;
		
		static internal var container:Sprite;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function remove():void {
			while (numChildren > 0)
				removeChildAt(0);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			container = this;
			
			originalImage = new OriginalImage();
			originalImage.onClick(null);
		}
		
	}
	
}