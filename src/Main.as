package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import nid.image.encoder.Encoder;
	import nid.image.encoder.JPEGEncoder;
	import nid.image.encoder.PNGEncoder;
	import nid.image.tools.BitmapMergeUtils;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class Main extends Sprite 
	{
		[Embed(source="../asset/Tranparant_smile.png")]
		private var img1Class:Class;
		
		[Embed(source="../asset/Gradient_ARGB.png")]
		private var img2Class:Class;
		
		private var file:FileReference;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var file:FileReference = new FileReference();
			var bitmap1:Bitmap = new img1Class();
			var bitmap2:Bitmap = new img2Class();
			var bmp_ba:ByteArray = bitmap1.bitmapData.getPixels(bitmap1.bitmapData.rect);
			
			var merged:BitmapData = BitmapMergeUtils.merge(bitmap1.bitmapData, bitmap2.bitmapData);
			var mergedBmp:Bitmap = new Bitmap(merged);
			addChild(mergedBmp);
			
			/**
			 * PNG encoder
			 */
			//var png:ByteArray = PNGEncoder.encode(merged, 300);
			//var png:ByteArray = PNGEncoder.encodeByteArray(bmp_ba, bitmap.width, bitmap.height, true, 300);
			//file.save(png, "sample.png");
			
			/**
			 * JPEG encoder
			 */
			//var jpgEncoder:JPEGEncoder = new JPEGEncoder()
			//var jpg:ByteArray = jpgEncoder.encode(bitmap.bitmapData, 300);
			//var jpg:ByteArray = jpgEncoder.encodeByteArray(bmp_ba, bitmap.width, bitmap.height,true,300);
			//file.save(jpg, "sample.jpg");
			
			/**
			 * EncodeWorker
			 */
			trace('Encoder Master');
			var encoder:Encoder = new Encoder();
			encoder.encodePNGAsync(merged, onComplete, 300);
		}
		
		private function onComplete(result:ByteArray):void 
		{
			trace('onComplete', result.length);
			file = new FileReference();
			file.save(result, "sample.png");
		}
		
	}
	
}