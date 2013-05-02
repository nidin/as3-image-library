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
			
			var bitmap:Bitmap = new imgClass();
			//var png:ByteArray = PNGEncoder.encode(bitmap.bitmapData, 72);
			//file.save(png, "sample.png");
			var jpgEncoder:JPEGEncoder = new JPEGEncoder()
			var jpg:ByteArray = jpgEncoder.encode(bitmap.bitmapData, 300);
			var file:FileReference = new FileReference();
			file.save(jpg, "sample.jpg");
		}
		
	}
	
}