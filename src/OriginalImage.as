package  
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class OriginalImage extends Sprite
	{
		
		private var fileName:TextInput;
		private var loadButton:Button;
		private var cb:ComboBox;
		
		private var bitMap:Bitmap;
		
		public function OriginalImage()
		{
			setComponent();
		}
		
		private function setComponent():void {
			fileName = new TextInput();
			fileName.move(10, 10);
			fileName.setSize(250, 20);
			fileName.text = "lena.jpg";
			addChild(fileName);
			
			loadButton = new Button();
			loadButton.setSize(60, 20);
			loadButton.move(350, 10);
			loadButton.label = "LOAD";
			addChild(loadButton);

			loadButton.addEventListener(MouseEvent.CLICK, onClick);
			
			
			cb = new ComboBox();
			cb.move(275, 10);
			cb.prompt = "SIZE";
			
			cb.addItem({label:(16).toString(), data:16});
			cb.addItem({label:(32).toString(), data:32});
			cb.addItem({label:(64).toString(), data:64});
			cb.addItem({label:(128).toString(), data:128});
			cb.addItem({label:(256).toString(), data:256});
			cb.addItem({label:(512).toString(), data:512});

			cb.setSize(60, 20);
			cb.addEventListener(Event.CHANGE, onChange);
			addChild(cb);			
			
			Main.container.addChild(this);
			
			//応急処置
//			loadButton.enabled = fileName.enabled = false;
		}
		
		
		private function onChange(event:Event):void {
			var cb:ComboBox = event.target as ComboBox;
			Main.SIZE = cb.selectedItem.data;

			onClick(null);
		}
		
		
		internal function onClick(event:MouseEvent):void {
			
			if (!fileName.text)
				return;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest(fileName.text), new LoaderContext(true));
			
		}
		
		private function onLoad(event:Event):void {
			
			var loader:Loader = event.currentTarget.loader;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(Main.SIZE / loader.width, Main.SIZE / loader.height); // 設定したいサイズ / 元サイズ
			
			var data:BitmapData = new BitmapData(Main.SIZE, Main.SIZE);			
			data.draw(loader, matrix);
			
			bitMap = new Bitmap(grayscale(data));
			addChild(bitMap);
			bitMap.x = 10;
			bitMap.y = 50;
			bitMap.scaleX = 256 / Main.SIZE;
			bitMap.scaleY = 256 / Main.SIZE;
			
			Main.freqImage = new FreqImage(bitMap);
			Main.pickFreq = new PickFreq(bitMap);
			Main.newBitmapData = new NewBitmapData();
		}

		private function grayscale(bd:BitmapData):BitmapData
		{
			var destbd:BitmapData = bd.clone();
 
			for (var y:int = 0; y < bd.height; y++)
				for (var x:int = 0; x < bd.width; x++) {

					var v:uint = destbd.getPixel(x, y);
					var r:uint = ((v & 0xff0000) >> 16) * 0.298912;
					var g:uint = ((v & 0xff00) >> 8) * 0.586611;
					var b:uint = (v & 0xff) * 0.114478;
					var gray:uint = r + g + b

					destbd.setPixel(x, y, gray << 16 | gray << 8 | gray);
				}
 
			return destbd;
		}
		
		
	}
	
}