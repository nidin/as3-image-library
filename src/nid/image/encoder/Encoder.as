package nid.image.encoder 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import nid.utils.Randomz;
	/**
	 * ...
	 * @author Nidin Vinayakan
	 */
	public class Encoder 
	{
		[Embed(source="../../../../bin/worker/EncodeWorker.swf", mimeType="application/octet-stream")]
		private var workerBin:Class;
		
		private var worker:Worker;
		private var toWorker:MessageChannel;
		private var fromWorker:MessageChannel;
		private var useWorker:Boolean;
		private var tasks:Dictionary;
		private var busy:Boolean;
		private var encodedData:ByteArray;
		
		public function Encoder(useWorker:Boolean=true) 
		{
			tasks = new Dictionary();
			this.useWorker = useWorker;
			if(useWorker){
				worker = WorkerDomain.current.createWorker(new workerBin());
				toWorker = Worker.current.createMessageChannel(worker);
				fromWorker = worker.createMessageChannel(Worker.current);
				
				worker.setSharedProperty("toWorker", toWorker);
				worker.setSharedProperty("fromWorker", fromWorker);
				
				fromWorker.addEventListener(Event.CHANNEL_MESSAGE, handleMessageFromWrorker);
				
				worker.start();
			}
		}
		
		private function handleMessageFromWrorker(e:Event):void 
		{
			trace('handleMessageFromWrorker');
			var message:Object = fromWorker.receive();
			var taskId:String = message.taskId;
			if(message.status == "success") {
				var callback:Function = tasks[taskId];
				var result:ByteArray = new ByteArray();
				encodedData = worker.getSharedProperty('encodedData');
				result.writeBytes(encodedData);
				callback(result);
			}else {
				callback(false);
			}
		}
		public function encodePNGAsync(data:BitmapData, callback:Function, dpi:int=72):void {
			var taskId:String = Randomz.randomString(6);
			tasks[taskId] = callback;
			busy = true;
			if (useWorker) {
				encodeInWorker(data, 'encodePNG', taskId, dpi);
			}else {
				//Asynchronous encoding not implemented without worker
			}
		}
		public function encodeJPGAsync(data:BitmapData, callback:Function, dpi:int = 72):void { 
			var taskId:String = Randomz.randomString(6);
			tasks[taskId] = callback;
			busy = true;
			if (useWorker) {
				encodeInWorker(data, 'encodeJPG', taskId, dpi);
			}
			else {
				//Asynchronous encoding not implemented without worker
			}
		}
		private function encodeInWorker(data:BitmapData, command:String, taskId:String, dpi:int):void {
			var bitmapBytes:ByteArray = new ByteArray();
			data.copyPixelsToByteArray(data.rect, bitmapBytes);
			worker.setSharedProperty('bitmapBytes', bitmapBytes);
			toWorker.send( { 
				command:command,
				taskId:taskId, 
				width:data.width,
				height:data.height,
				transparent:data.transparent,
				dpi:dpi 
			} );
		}
	}

}