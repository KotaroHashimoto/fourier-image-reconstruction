package  
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PickFreq extends FreqImage
	{
		public function PickFreq(img:Bitmap)
		{
			super(img);
			y += 276;
			
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void {
			
			var k1:uint = (uint)(event.localX);
			var k2:uint = (uint)(event.localY);
			
//			trace(k1 + ", " + k2);
			
			if (imgData.getPixel(k1, k2) == 0x0)
				return;
						
			var index:uint = k1 + k2 * Main.SIZE;
			
			imgData.setPixel(k1, k2, 0x0);
			Main.newBitmapData.addFreq(re[index], im[index], k1, k2);
		}
		
		
		private function onMove(event:MouseEvent):void {
			
			if (!event.buttonDown)
				return;
			
			onClick(event);
		}
		
		
	}
	
}
