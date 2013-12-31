package com.coolexp.manager
{
	import com.coolexp.events.ActionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.core.Application;

	[Event(name="check_soft_event", type="com.coolexp.events.ActionEvent")]
	public class ToolerCheck extends EventDispatcher
	{
		private static var _instance:ToolerCheck;
		private static const url:String = "http://www.coolexp.com/tooler.php";
		private var urlLoader:URLLoader; 
		public function ToolerCheck()
		{
		}
		public static function getInstance():ToolerCheck{
			if(!_instance){
				_instance = new ToolerCheck();
			}
			return _instance;
		}
		public function check():void{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			var paras:URLVariables = new URLVariables();
			paras.type = "animation";
			paras.version = "1.0.0";
			var request:URLRequest = new URLRequest(url);
			request.data = paras;
			request.method = flash.net.URLRequestMethod.POST;
			urlLoader.load(request);
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var data:String = event.target.data as String;
			var obj:Object = JSON.parse(data);
			if(obj.result==1){
				trace("Success");
				checkResultHandler(1);
			}else{
				checkResultHandler(2);
			}
			dispose();
		}
		private function checkResultHandler(val:int):void{
			var evt:ActionEvent = new ActionEvent(ActionEvent.CHECK_SOFT_EVENT);
			evt.result = val;
			this.dispatchEvent(evt);
		}
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			checkResultHandler(3);
			dispose();
		}
		private function dispose():void{
			if(urlLoader){
				urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				urlLoader = null;
			}
		}
	}
}