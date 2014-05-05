package com.coolexp.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import spark.components.TextArea;
	
	public class LogManager extends EventDispatcher
	{
		public function LogManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		private static var _instance:LogManager;
		public static function getInstance():LogManager{
			if(_instance==null){
				_instance = new LogManager();
			}
			return _instance;
		}
		private var txt:TextArea;
		public function init(t:TextArea):void{
			txt = t;
		}
		public function log(...args):void{
			if(txt){
				txt.appendText(args.join(",")+"\n");
			}
		}
	}
}