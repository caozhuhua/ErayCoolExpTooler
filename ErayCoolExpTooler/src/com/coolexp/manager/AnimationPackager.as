package com.coolexp.manager
{
	import com.coolexp.vo.BaseFileVO;
	import com.coolexp.vo.FileTypeVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	
	public class AnimationPackager extends EventDispatcher
	{
		private static var _instance:AnimationPackager;
		private var pckType:int;
		private var isDel:Boolean;
		public var fileId:int = 10001;
		public function AnimationPackager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():AnimationPackager{
			if(!_instance){
				_instance = new AnimationPackager();
			}
			return _instance;
		}
		public function packAnimationFile(file:File,type:int,isDeleteOriginal:Boolean):void{
			pckType = type;
			isDel = isDeleteOriginal;
			var isPack:Boolean = false;
			if(pckType==1){
				isPack = analyseFile(file);
				if(isPack){
					Alert.show("打包成功");
				}
			}else{
				var b:Array = [];
				analyseDic(file,b);
				var f:File;
				for(var i:int = 0,l:int = b.length;i<l;++i){
					f = b[i];
					isPack = analyseFile(f);
					if(!isPack){
						return;
					}
				}
				Alert.show("打包成功");
			}
//			Alert.show("打包成功");
		}
		private function analyseFile(file:File):Boolean{
			var prefixPath:String = file.nativePath.replace(file.name, "");
			var prefixName:String = file.name.replace(file.type, "");
			var xmlFile:File = new File(((prefixPath + prefixName) + ".xml"));
			if(xmlFile.exists){
				var swfBa:ByteArray = FilePackManager.getInstance().getFileData(file);
				var xmlBa:ByteArray = FilePackManager.getInstance().getFileData(xmlFile);
				if(isDel){
					file.deleteFile();
					xmlFile.deleteFile();
				}
				saveAnimationFile(prefixPath,prefixName,swfBa,xmlBa);
			}else{
				Alert.show(prefixName+".XML文件不存在");
				return false;
			}
			return true;
		}
		private function saveAnimationFile(prefixPath:String,fileName:String,swfData:ByteArray,xmlData:ByteArray):void{
//			var fileType:int = ba.readUnsignedInt();
//			var fileId:int = ba.readUnsignedInt();
//			var fileName:String = ba.readUTF();
//			var isGroup:int = ba.readUnsignedInt();
			
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(FileTypeVO.ANI_2_TYPE);
			ba.writeUnsignedInt(this.fileId++);
			ba.writeUTF(fileName+".erayswf");
			ba.writeUnsignedInt(2);
			ba.writeUnsignedInt(2);
			
			var xmlFileBa:ByteArray = encodeFile(xmlData,5,this.fileId++,fileName+".xml",1);
			var swfFileBa:ByteArray = encodeFile(swfData,1,this.fileId++,fileName+".swf",1);
			ba.writeUnsignedInt(xmlFileBa.length);
			ba.writeBytes(xmlFileBa);
			ba.writeUnsignedInt(swfFileBa.length);
			ba.writeBytes(swfFileBa);
			
			var fileBa:ByteArray = new ByteArray();
			fileBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			fileBa.writeUnsignedInt(ba.length);
			fileBa.writeBytes(ba);
			
			var file:File = new File(prefixPath+fileName+".erayswf.dat");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(fileBa);
			fs.close();
		}
		private function encodeFile(byteArray:ByteArray,fileType:int,fileId:int,fileName:String,isGroup:int,compress:int = 2,compressType:int=0,groupType:int = 1):ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(fileType);
			ba.writeUnsignedInt(fileId);
			ba.writeUTF(fileName);
			ba.writeUnsignedInt(isGroup);
			ba.writeUnsignedInt(compress);
			ba.writeUnsignedInt(compressType);
			ba.writeUnsignedInt(groupType);
			ba.writeBytes(byteArray);
			
			var fileBa:ByteArray = new ByteArray();
			fileBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			fileBa.writeUnsignedInt(ba.length);
			fileBa.writeBytes(ba);
			return fileBa;
		}
									
	
		private function analyseDic(file:File,a:Array):void{
			var b:Array = file.getDirectoryListing();
			var f:File;
			for(var i:int = 0,l:int = b.length;i<l;++i){
				f = b[i];
				if(f.isDirectory){
					analyseDic(f,a);
				}else{
					if(f.extension.indexOf("swf")>=0){
						a.push(f);
					}
				}
				
			}
		}
	}
}