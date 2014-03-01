package com.coolexp.manager
{
	import com.coolexp.vo.BaseFileVO;
	import com.coolexp.vo.FileTypeVO;
	import com.coolexp.vo.GroupFileVO;
	import com.coolexp.vo.SimpleFileVO;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

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
			var f:File,fileVO:*;
			var fileList:Array = [];
			for(var i:int = 0,l:int = list.length;i<l;++i){
				f = list[i];
				fileVO = SimpleFileVO.parseFile(f);
				if(fileVO!=null){
					if(fileVO is ByteArray){
						fileList.push(fileVO); 
						continue;
					}
				}else{
					fileVO = BaseFileVO.parse(getFileData(f)) as SimpleFileVO;
				}
				fileList.push(fileVO);
			}
			var g:GroupFileVO = GroupFileVO.parseFile(file.name+".group",AnimationPackager.getInstance().fileId++,FileTypeVO.GAME_G_TYPE,fileList);
			var basePath:String = file.nativePath.replace(file.name,"");
			saveFile(basePath+fileName,g.toByteArray());
		}
		public function rename(file:File,ext:String):void{
			var a:Array = [];
			if(file.isDirectory){
				a = getFileList(file);
			}else{
				a.push(file);
			}
			var f:File;
			var filePath:String;
			var ba:ByteArray;
			for(var i:int = 0,l:int = a.length;i<l;++i){
				f = a[i];
				if(f.name.indexOf(".dat")<0){
					filePath = f.nativePath;
					ba = this.getFileData(f);
					f.deleteFile();
					this.saveFile(filePath+ext,ba);
				}
			}
		}
		public function unEncode(file:File,isDel:Boolean):void{
			var a:Array = [];
			if(file.isDirectory){
				a = getFileList(file);
			}else{
				a.push(file);
			}
			var f:File;
			var filePath:String;
			var ba:ByteArray;
			var b:BaseFileVO;
			for(var i:int = 0,l:int = a.length;i<l;++i){
				f = a[i];
				filePath = f.nativePath.replace(f.name,"");
				ba = this.getFileData(f);
				var isEn:Boolean = isEncode(ba);
				if(!isEn){
					continue;
				}
				if(isDel){
					f.deleteFile();
				}
				b = BaseFileVO.parse(ba);
				if(b.isGroup==2){
					var fg:GroupFileVO = GroupFileVO(b);
					for(var j:int = 0,k:int = fg.fileNum;j<k;++j){
						saveSimpleFileVOToFile(fg.fileList[i],filePath);
					}
				}else if(b.isGroup==1){
					saveSimpleFileVOToFile(b as SimpleFileVO,filePath);
				}
			}
		}
		public function isEncode(ba:ByteArray):Boolean{
			ba.position = 0;
			if(ba.length>BaseFileVO.fileHeadStrLength){
				var fileHeadString:String = ba.readUTFBytes(BaseFileVO.fileHeadStrLength);
				if(fileHeadString==BaseFileVO.FILE_HEAD_STR){
					ba.position = 0;
					return true;
				}
			}
			ba.position = 0;
			return false;
		}
		private function saveSimpleFileVOToFile(s:SimpleFileVO,basePath:String):void{
			var filePath:String = basePath+s.fileName;
			this.saveFile(filePath,s.fileBa);
		}
		public function encode(file:File,isDel:Boolean):void{
			var a:Array = [];
			if(file.isDirectory){
				a = getFileList(file);
			}else{
				a.push(file);
			}
			var f:File,fileVO:SimpleFileVO;
			var filePath:String;
			for(var i:int = 0,l:int = a.length;i<l;++i){
				f = a[i];
				fileVO = SimpleFileVO.parseFile(f);
				filePath = f.nativePath;
				if(isDel){
					f.deleteFile();
				}
				if(fileVO!=null){
					saveFile(filePath,fileVO.toByteArray());
				}
				
			}
			Alert.show("加密成功");
		}
		/**
		 * 写入文件 
		 * @param path
		 * @param ba
		 * 
		 */		
		public function saveFile(path:String,ba:ByteArray):File{
			var file:File = new File(path);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			return file;
		}
		/**
		 * 得到文件夹下的所有文件，形成一个数组 
		 * @param file
		 * @return 
		 * 
		 */		
		public function getFileList(file:File):Array{
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