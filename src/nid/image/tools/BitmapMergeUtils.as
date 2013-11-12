package nid.image.tools 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class BitmapMergeUtils 
	{
		/**
		 * Merge two bitmapdata with transparency
		 * @param	BitmapData 1
		 * @param	BitmapData 2
		 * @return BitmapData
		 */
		public static function merge(bmp1:BitmapData, bmp2:BitmapData):BitmapData {
			
			var width:int = Math.max(bmp1.width, bmp2.width);
			var height:int = Math.max(bmp1.height, bmp2.height);
			
			var sourceARGB:uint, sourceA:uint, sourceR:uint, sourceG:uint, sourceB:uint;
			var targetARGB:uint, targetA:uint, targetR:uint, targetG:uint, targetB:uint;
			var mergedARGB:uint, mergedA:uint, mergedR:uint, mergedG:uint, mergedB:uint;
			
			var mergedBmp:BitmapData = new BitmapData(width, height);
			
			for (var y:int = 0; y < height; y++) {
				for (var x:int = 0; x < width; x++) {
					
					sourceARGB = bmp1.getPixel32(x, y);
					targetARGB = bmp2.getPixel32(x, y);
					targetA = targetARGB >> 24 & 0xff
					
					if (targetA == 0) {
						
						mergedBmp.setPixel32(x, y, sourceARGB);
					}
					else if (targetA < 0xff) {
						
						sourceA = sourceARGB >> 24 & 0xff
						sourceR = sourceARGB >> 16 & 0xff
						sourceG = sourceARGB >> 8 & 0xff
						sourceB = sourceARGB  & 0xff;
						
						targetR = targetARGB >> 16 & 0xff;
						targetG = targetARGB >> 8 & 0xff;
						targetB = targetARGB  & 0xff;
						
						var src:Number = sourceA / 0xff;
						var tgt:Number = targetA / 0xff;
						
						mergedR = (src * sourceR + tgt * targetR * (1 - src));
						mergedG = (src * sourceG + tgt * targetG * (1 - src));
						mergedB = (src * sourceB + tgt * targetB * (1 - src));
						
						mergedA = ((src + tgt * (1 - src)) * 0xff);
						
						mergedARGB = (mergedA << 24) | (mergedR << 16) | (mergedG << 8) | mergedB;
						
						mergedBmp.setPixel32(x, y, mergedARGB);
						
					}
					else {
						mergedBmp.setPixel32(x, y, targetARGB);
					}
				}	
			}
			
			return mergedBmp;
		}
	}

}