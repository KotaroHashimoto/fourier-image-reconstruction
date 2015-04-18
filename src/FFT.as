package {

	public class FFT{
		private var n:int; // データ数
		private var bitrev:Array; // ビット反転テーブル
		private var cstb:Array; // 三角関数テーブル
		public static const HPF:String = "high";
		public static const LPF:String = "low";
		public static const BPF:String = "band"

		
		private function getArray(n:uint):Array {
			
			var v:Array = new Array();
			for (var i:uint = 0; i < n; i++ )
				v.push(0);
				
			return v;
		}		
		
		
		public function FFT(n:int) {
			if(n != 0 && (n & (n-1)) == 0) {
				this.n = n;
				this.cstb = getArray(n + (n>>2));
				this.bitrev = getArray(n);
				makeCstb();
				makeBitrev();
			}	
		}
		// 1D-FFT
		public function fft(re:Array, im:Array, inv:Boolean=false):void {
			if(!inv) {
				fftCore(re, im, 1);
			}else {
				fftCore(re, im, -1);
				for(var i:int=0; i<n; i++) { 
					re[i] /= n;
					im[i] /= n;
				}
			}
		}
		// 2D-FFT
		public function fft2d(re:Array, im:Array, inv:Boolean=false):void {
			var tre:Array = getArray(re.length);
			var tim:Array = getArray(im.length);
			
			
			if (inv) cvtSpectrum(re, im);

			// x軸方向のFFT
			for(var y:int=0; y<n; y++) {
				for(var x:int=0; x<n; x++) {
					tre[x] = re[x + y*n];
					tim[x] = im[x + y*n];
				}
				if(!inv) fft(tre, tim);
				else fft(tre, tim, true);
				for(x=0; x<n; x++) {
					re[x + y*n] = tre[x];
					im[x + y*n] = tim[x];
				}
			}
			// y軸方向のFFT
			for(x=0; x<n; x++) {
				for(y=0; y<n; y++) {
					tre[y] = re[x + y*n];
					tim[y] = im[x + y*n];
				}
				if(!inv) fft(tre, tim);
				else fft(tre, tim, true);
				for(y=0; y<n; y++) {
					re[x + y*n] = tre[y];
					im[x + y*n] = tim[y];
				}
			}
			if (!inv) cvtSpectrum(re, im);
		}
		
		
		// 空間周波数フィルタ
		public function applyFilter(re:Array, im:Array, rad:uint, type:String, bandWidth:uint = 0):void {
			var r:int = 0; // 半径
			var n2:int = n>>1;
			for(var y:int=-n2; y<n2; y++) {
				for(var x:int=-n2; x<n2; x++) {
					r = Math.sqrt(x*x + y*y);
					if((type == HPF && r<rad) || (type == LPF && r>rad) || (type == BPF && (r<rad || r>(rad + bandWidth)))) {
							re[x + n2 + (y + n2)*n] = im[x + n2 + (y + n2)*n] = 0;
					}
				}
			}
		}
		private function fftCore(re:Array, im:Array, sign:int):void {
			var h:int, d:int, wr:Number, wi:Number, ik:int, xr:Number, xi:Number, m:int, tmp:Number;
			for(var l:int=0; l<n; l++) { // ビット反転
				m = bitrev[l];
				if(l<m) {
					tmp = re[l];
					re[l] = re[m];
					re[m] = tmp;
					tmp = im[l];
					im[l] = im[m];
					im[m] = tmp;
				}
			}
			for(var k:int=1; k<n; k<<=1) { // バタフライ演算
				h = 0;
				d = n/(k<<1);
				for(var j:int=0; j<k; j++) {
					wr = cstb[h + (n>>2)];
					wi = sign*cstb[h];
					for(var i:int=j; i<n; i+=(k<<1)) {
						ik = i+k;
						xr = wr*re[ik] + wi*im[ik]
						xi = wr*im[ik] - wi*re[ik];
						re[ik] = re[i] - xr;
						re[i] += xr;
						im[ik] = im[i] - xi;
						im[i] += xi;
					}
					h += d;
				}
			}
		}
		// スペクトル位置並び替え
		public function cvtSpectrum(re:Array, im:Array):void {
			var tmp:Number = 0.0, xn:int = 0, yn:int = 0;
			for(var y:int=0; y<(n>>1); y++) {
				for(var x:int=0; x<(n>>1); x++) {
					xn = x + (n>>1);
					yn = y + (n>>1);
					tmp = re[x + y*n];
					re[x + y*n] = re[xn + yn*n];
					re[xn + yn*n] = tmp;
					tmp = re[x + yn*n];
					re[x + yn*n] = re[xn + y*n];
					re[xn + y*n] = tmp;
					tmp = im[x + y*n];
					im[x + y*n] = im[xn + yn*n];
					im[xn + yn*n] = tmp;
					tmp = im[x + yn*n];
					im[x + yn*n] = im[xn + y*n];
					im[xn + y*n] = tmp;
				}
			}
		}
		// 三角関数テーブル作成
		private function makeCstb():void {
			var n2:int = n>>1, n4:int = n>>2, n8:int = n>>3;
			var t:Number = Math.sin(Math.PI/n);
			var dc:Number = 2*t*t;
			var ds:Number = Math.sqrt(dc*(2 - dc));
			var c:Number = cstb[n4] = 1;
			var s:Number = cstb[0] = 0;
			t = 2*dc;
			for(var i:int=1; i<n8; i++) {
				c -= dc;
				dc += t*c;
				s += ds;
				ds -= t*s;
				cstb[i] = s;
				cstb[n4 - i] = c;
			}
			if(n8 != 0) cstb[n8] = Math.sqrt(0.5);
			for(var j:int=0; j<n4; j++) cstb[n2 - j] = cstb[j];
			for(var k:int=0; k<(n2 + n4); k++) cstb[k + n2] = -cstb[k];
		}
		// ビット反転テーブル作成
		private function makeBitrev():void {
			var i:int = 0, j:int = 0, k:int = 0;
			bitrev[0] = 0;
			while(++i<n) {
				k = n >> 1;
				while(k<=j) {
					j -= k;
					k >>= 1;
				}
				j += k;
				bitrev[i] = j;
			}
		}
	}
}