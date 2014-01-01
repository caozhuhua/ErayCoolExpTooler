package com.coolexp.manager
{
	import com.coolexp.vo.FileTypeVO;
	import com.coolexp.vo.GroupFileVO;
	import com.coolexp.vo.SimpleFileVO;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FilePackManager extends EventDispatcher
	{
		private static var _instance:FilePackManager;
		public function FilePackManager()
		{
		}
		public static function getInstance():FilePackManager{
			if(_instance==null){
				_instance = new FilePackManager();
			}
			return _instance;
		}
		/**
		 * 打包初始化文件 
		 * @param file
		 * @param fileName
		 * 
		 */		
		public function packGameRes(file:File,fileName:String):void{
			var list:Array = getFileList(file);
			var f:File,fileVO:SimpleFileVO;
			var fileList:Array = [];
			for(var i:int = 0,l:int = list.length;i<l;++i){
				f = list[i];
				fileVO = SimpleFileVO.parseFile(f);
				fileList.push(fileVO);
			}
			var g:GroupFileVO = GroupFileVO.parseFile(f.name+".group",AnimationPackager.getInstance().fileId++,FileTypeVO.GAME_G_TYPE,fileList);
			var basePath:String = file.nativePath.replace(file.name,"");
			saveFile(basePath+fileName,g.toByteArray());
			
		}
		/**
		 * 写入文件 
		 * @param path
		 * @param ba
		 * 
		 */		
		public function saveFile(path:String,ba:ByteArray):void{
			var file:File = new File(path);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
		}
		/**
		 * 得到文件夹下的所有文件，形成一个数组 
		 * @param file
		 * @return 
		 * 
		 */		
		private function getFileList(file:File):Array{
			var list:Array = [];
			getFileFromDic(file,list);
			
			return list;
		}
		private function getFileFromDic(file:File,list:Array):void{
			var a:Array = file.getDirectoryListing();
			for(var i:int = 0,l:int = a.length;i<l;++i){
				var f:File = a[i];
				if(f.isDirectory){
					getFileFromDic(f,list);
				}else{
					list.push(f);
				}
			}
		}
		/**
		 * 获取文件信息 
		 * @param file
		 * @return 
		 * 
		 */		
		public function getFileData(file:File):ByteArray{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba);
			fs.close();
			ba.position = 0;
			return ba;
		}
		
	}
}