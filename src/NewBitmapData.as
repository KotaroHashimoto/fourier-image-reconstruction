package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NewBitmapData extends Sprite
	{
		internal var bd:BitmapData;
		private var reMap:Array;
		
		private var NN:uint;
		private var pi2N:Number;
		
		public function NewBitmapData() 
		{
			NN = Main.SIZE * Main.SIZE;
			pi2N = 2 * Math.PI / Main.SIZE;
			
			scaleX = 256 / Main.SIZE;
			scaleY = 256 / Main.SIZE;
			reMap = new Array();

			bd = new BitmapData(Main.SIZE, Main.SIZE);
			
			for (var i:uint = 0; i < Main.SIZE; i++ )
				for (var j:uint = 0; j < Main.SIZE; j++ ) {
					bd.setPixel(i, j, 0x0);
					reMap.push(0);
				}					
					
			x = 10;
			y = 276 + 50;
			
			rotation = 180;
			x += 256;
			y += 256;

			addChild(new Bitmap(bd));
			Main.container.addChild(this);
			
		}
		
		
		internal function addFreq(re:Number, im:Number, k1:Number, k2:Number):void {
						
			var max:Number = -Number.MAX_VALUE;			
			var min:Number = Number.MAX_VALUE;			
			
			for (var n1:uint = 0; n1 < Main.SIZE; n1++ )
				for (var n2:uint = 0; n2 < Main.SIZE; n2++ ) {
					
					var cmp:Number = (n1 * k1 + n2 * k2) * pi2N;
					var v:Number = Math.abs(reMap[n1 + n2 * Main.SIZE] += ((re * Math.cos(cmp) + im * Math.sin(cmp)) / NN));
					
					if (v > max)
						max = v;
					else if (v < min)
						min = v;
				}
				
			for (n1 = 0; n1 < Main.SIZE; n1++ )
				for (n2 = 0; n2 < Main.SIZE; n2++ ) {
					
					var vu:uint = (uint)((Math.abs(reMap[n1 + n2 * Main.SIZE]) - min) * 255 / (max - min)) & 0xff;

					bd.setPixel(n1, n2, (vu << 16) | (vu << 8) | vu);
				}

		}
		
	}
	
}
