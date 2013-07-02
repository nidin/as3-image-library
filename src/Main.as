package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import nid.image.encoder.JPEGEncoder;
	import nid.image.encoder.PNGEncoder;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "../asset/Penguins.jpg")]
		private var imgClass:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var file:FileReference = new FileReference();
			var bitmap:Bitmap = new imgClass();
			var bmp_ba:ByteArray = bitmap.bitmapData.getPixels(bitmap.bitmapData.rect);
			
			/**
			 * PNG encoder
			 */
			//var png:ByteArray = PNGEncoder.encode(bitmap.bitmapData, 72);
			//var png:ByteArray = PNGEncoder.encodeByteArray(bmp_ba, bitmap.width, bitmap.height, true, 300);
			//file.save(png, "sample.png");
			
			/**
			 * JPEG encoder
			 */
			var jpgEncoder:JPEGEncoder = new JPEGEncoder()
			//var jpg:ByteArray = jpgEncoder.encode(bitmap.bitmapData, 300);
			var jpg:ByteArray = jpgEncoder.encodeByteArray(bmp_ba, bitmap.width, bitmap.height,true,300);
			file.save(jpg, "sample.jpg");
		}
		
	}
	
}