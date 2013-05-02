package nid.image.encoder
{

import flash.display.BitmapData;
import flash.utils.ByteArray;

	public class PNGEncoder
	{

		private static const CONTENT_TYPE:String = "image/png";

		public function PNGEncoder()
		{
			super();
		}

		private static var crcTable:Array;

		public static function get contentType():String
		{
			return CONTENT_TYPE;
		}

		public static function encode(bitmapData:BitmapData,dpi:Number=0):ByteArray
		{
			initializeCRCTable();
			return internalEncode(bitmapData, bitmapData.width, bitmapData.height,bitmapData.transparent, dpi);
		}

		public static function encodeByteArray(byteArray:ByteArray, width:int, height:int, transparent:Boolean = true):ByteArray
		{
			initializeCRCTable();
			return internalEncode(byteArray, width, height, transparent);
		}

		private static function initializeCRCTable():void
		{
			if (crcTable == null)
			{
				crcTable = [];
				for (var n:uint = 0; n < 256; n++)
				{
					var c:uint = n;
					for (var k:uint = 0; k < 8; k++)
					{
						if (c & 1)
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						else
							c = uint(c >>> 1);
					 }
					crcTable[n] = c;
				}
			}
		}

		private static function internalEncode(source:*, width:int, height:int, transparent:Boolean, dpi:Number=0):ByteArray
		{
			// The source is either a BitmapData or a ByteArray.
			var sourceBitmapData:BitmapData = source as BitmapData;
			var sourceByteArray:ByteArray = source as ByteArray;
			
			if (sourceByteArray)
				sourceByteArray.position = 0;
			
			// Create output byte array
			var png:ByteArray = new ByteArray();

			// Write PNG signature
			png.writeUnsignedInt(0x89504E47);
			png.writeUnsignedInt(0x0D0A1A0A);

			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(width);
			IHDR.writeInt(height);
			IHDR.writeByte(8); // bit depth per channel
			IHDR.writeByte(6); // color type: RGBA
			IHDR.writeByte(0); // compression method
			IHDR.writeByte(0); // filter method
			IHDR.writeByte(0); // interlace method
			writeChunk(png, 0x49484452, IHDR);
			if (dpi > 0)
			{
				var pHYs:ByteArray = new ByteArray();\
				dpi = dpi / 0.0254;
				pHYs.writeUnsignedInt(dpi);//Pixels per unit, X axis
				pHYs.writeUnsignedInt(dpi);//Pixels per unit, Y axis
				pHYs.writeByte(1);
				writeChunk(png, 0x70485973, pHYs);
			}
			
			//70 48 59 73 pHYs Physical pixel dimensions
			
			// Build IDAT chunk
			var IDAT:ByteArray = new ByteArray();
			for (var y:int = 0; y < height; y++)
			{
				IDAT.writeByte(0); // no filter

				var x:int;
				var pixel:uint;
				
				if (!transparent)
				{
					for (x = 0; x < width; x++)
					{
						if (sourceBitmapData)
							pixel = sourceBitmapData.getPixel(x, y);
						else
							pixel = sourceByteArray.readUnsignedInt();
						
						IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | 0xFF));
					}
				}
				else
				{
					for (x = 0; x < width; x++)
					{
						if (sourceBitmapData)
							pixel = sourceBitmapData.getPixel32(x, y);
						else
							pixel = sourceByteArray.readUnsignedInt();
	 
						IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) |
													(pixel >>> 24)));
					}
				}
			}
			IDAT.compress();
			writeChunk(png, 0x49444154, IDAT);

			// Build IEND chunk
			writeChunk(png, 0x49454E44, null);

			// return PNG
			png.position = 0;
			return png;
		}

		private static function writeChunk(png:ByteArray, type:uint, data:ByteArray):void
		{
			// Write length of data.
			var len:uint = 0;
			if (data)
				len = data.length;
			png.writeUnsignedInt(len);
			
			// Write chunk type.
			var typePos:uint = png.position;
			png.writeUnsignedInt(type);
			
			// Write data.
			if (data)
				png.writeBytes(data);

			// Write CRC of chunk type and data.
			var crcPos:uint = png.position;
			png.position = typePos;
			var crc:uint = 0xFFFFFFFF;
			for (var i:uint = typePos; i < crcPos; i++)
			{
				crc = uint(crcTable[(crc ^ png.readUnsignedByte()) & uint(0xFF)] ^
						   uint(crc >>> 8));
			}
			crc = uint(crc ^ uint(0xFFFFFFFF));
			png.position = crcPos;
			png.writeUnsignedInt(crc);
		}
	}
}
