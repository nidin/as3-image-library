/**
* @mxmlc -o=bin/worker/EncodeWorker.swf -load-config+=obj\as3-image-libraryConfig.xml -debug=true -swf-version=17
*/
package nid.image.worker 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import nid.image.encoder.JPEGEncoder;
	import nid.image.encoder.PNGEncoder;

	/**
	 * ...
	 * @author Nidin Vinayakan
	 * @company RTT AG | Munich | Germany
	 */
	public class EncodeWorker extends Sprite
	{
		private var toWorker:MessageChannel;
		private var fromWorker:MessageChannel;
		private var jpgEncoder:JPEGEncoder;
		private var bitmapBytes:ByteArray;
		private var encodedData:ByteArray;
		
		public function EncodeWorker() 
		{
			if (!Worker.current.isPrimordial) {
				trace('Encoder Worker');
				toWorker = Worker.current.getSharedProperty("toWorker");			
				fromWorker = Worker.current.getSharedProperty("fromWorker");
				
				bitmapBytes = Worker.current.getSharedProperty('bitmapBytes');
				
				toWorker.addEventListener(Event.CHANNEL_MESSAGE, handleMessageFromMaster);
			}
		}
		
		private function handleMessageFromMaster(e:Event):void 
		{
			trace('handleMessageFromMaster');
			var message:Object = toWorker.receive();
			
			switch(message.command) {
				case 'encodePNG':
					var result:ByteArray = PNGEncoder.encodeByteArray(
						bitmapBytes, 
						message.width, 
						message.height, 
						message.transparent, 
						message.dpi == undefined?72:message.dpi
					);
					result.position = 0;
					encodedData = new ByteArray();
					encodedData.writeBytes(result);
					encodedData.shareable = true;
					Worker.current.setSharedProperty('encodedData', encodedData);
					fromWorker.send( { status:"success", taskId:message.taskId } );
					break;
				case 'encodeJPG':
					if (jpgEncoder == null) jpgEncoder = new JPEGEncoder();
					result = jpgEncoder.encodeByteArray(
						bitmapBytes, 
						message.width, 
						message.height, 
						message.transparent, 
						message.dpi == undefined?72:message.dpi
					);
					result.position = 0;
					encodedData = new ByteArray();
					encodedData.writeBytes(result);
					encodedData.shareable = true;
					Worker.current.setSharedProperty('encodedData', encodedData);
					fromWorker.send( { status:"success", taskId:message.taskId } );
					break;
			}
		}
		
	}
		
}