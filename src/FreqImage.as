package {

	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class FreqImage extends Sprite {

		internal var imgData:BitmapData;
		private var fftFreqImage:FFT;
		internal var re:Array;
		internal var im:Array;
		private var ab:Array;
		private var max:Number = 0;
		private var data:Number;
		private var w:uint;
		private var h:uint;
		
		
		private function getArray(n:uint):Array {
			
			var v:Array = new Array();
			for (var i:uint = 0; i < n; i++ )
				v.push(0);
				
			return v;
		}
		

		public function FreqImage(srcBmp:Bitmap) {
			imgData = srcBmp.bitmapData.clone();
			w = imgData.width;
			h = imgData.height;
			var wh:uint = w * h;
			fftFreqImage = new FFT(w);
			re = getArray(wh);
			im = getArray(wh);
			ab = getArray(wh);
			// 画像データの直列化
			for(var y:int=0; y<h; y++) {
				for(var x:int=0; x<w; x++) {
					re[x + y*w] = imgData.getPixel(x, y) & 0xff;
				}
			}
//			var ts:int = getTimer();
			// 二次元離散フーリエ変換
			fftFreqImage.fft2d(re, im);
//			var te:int = getTimer();
//			trace("time FFT: "+(te-ts)+" ms");
			// スペクトルの振幅を計算
			
			for(var i:uint=0; i < wh; i++) {
				ab[i] = Math.log(Math.sqrt(re[i]*re[i] + im[i]*im[i]));

//				var imgn:Number = im[i] * im[i];
//				im[i] = Math.atan2(im[i], re[i]);
//				re[i] = Math.sqrt(re[i] * re[i] + imgn);
				
				if(ab[i] > max) max = ab[i];
			}
						
			// 正規化
			for(i=0; i<wh; i++) {
				ab[i] = ab[i]*255/max;
			}
			// 振幅画像の生成
			for(y=0; y<h; y++) {
				for(x=0; x<w; x++) {
					data = ab[x + y*w];
					if(data>255) data = 255;
					if(data<0) data = 0;
					var color:uint = data<<16 | data<<8 | data;
					imgData.setPixel(x, y, color);
				}
			}

			addChild(new Bitmap(imgData));
			this.x = 286;
			this.y = 50;
			
			scaleX = 256 / Main.SIZE;
			scaleY = 256 / Main.SIZE;
			
			Main.container.addChild(this);

		}
	}
}
