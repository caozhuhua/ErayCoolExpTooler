package com.coolexp.manager
{
	import com.coolexp.vo.KeyVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class SWFHelperManager extends EventDispatcher
	{
		private static var _instance:SWFHelperManager;
		private var keyVO:KeyVO;
		private var type:int;
		private var filePath:String;
		public function SWFHelperManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():SWFHelperManager{
			if(_instance==null){
				_instance = new SWFHelperManager();
			}
			return _instance;
		}
		/**
		 * 
		 * @param _type 1,加密 0，解密
		 * @param _keyVO
		 * 
		 */		
		public function unKnowSWF(_type:int,_keyVO:KeyVO):void{
			keyVO = _keyVO;
			type = _type;
			var file:File = new File();
			file.addEventListener(Event.SELECT,onSelectFileHandler);
			file.browse([new FileFilter("SWF","*.swf")]);
		}
		
		protected function onSelectFileHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var file:File = event.target as File;
			if(file){
				file.removeEventListener(Event.SELECT,onSelectFileHandler);
				filePath = file.nativePath;
				var ba:ByteArray = FilePackManager.getInstance().getFileData(file);
				file.deleteFile();
				var prefixInfo:String = "操作";
				if(type==1){
					this.pack(ba);
					prefixInfo = "加密";
				}else{
					this.unPack(ba);
					prefixInfo = "解密";
				}
				Alert.show(prefixInfo+"成功","信息");
			}
		}
		private function pack(ba:ByteArray):void{
			var secert:int = keyVO.key_1*keyVO.key_2;
			for(var i:int = 0,l:int = ba.length;i<l;++i){
				var ch:int = ba[i];
				trace(ch);
				ch = ch ^secert;
				ba[i] = ch;
			}
			FilePackManager.getInstance().saveFile(filePath,ba);
		}
		private function unPack(ba:ByteArray):void{
			var secert:int = keyVO.key_1*keyVO.key_2;
			for(var i:int = 0,l:int = ba.length;i<l;++i){
				var ch:int = ba[i];
				ch = ch ^secert;
				ba[i] = ch;
				trace(ch);
			}
			FilePackManager.getInstance().saveFile(filePath,ba);
		}
	}
}