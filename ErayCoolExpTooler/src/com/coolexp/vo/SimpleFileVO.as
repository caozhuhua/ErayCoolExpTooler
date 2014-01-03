package com.coolexp.vo
{
	import com.coolexp.manager.AnimationPackager;
	import com.coolexp.manager.FilePackManager;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class SimpleFileVO extends BaseFileVO
	{
		
		private static const FILE_LIST:Array = ["swf","mp3","png","jpg","xml","dat"];
		public function SimpleFileVO()
		{
		}
		/**
		 *1，为压缩，2，为未压缩 
		 */		
		public var isCompress:int;
		/**
		 *1，为”zlib”,  2,为”lzma”,0,为不压缩 
		 */		
		public var compressType:int;
		/**
		 *文件的组织方式，只适合图片，其他的不适合1,原始数据，2，为压缩后的BitmapData数据 
		 */		
		public var groupType:int;
		public var fileBa:ByteArray;
		
		override public function toByteArray():ByteArray{
			var ba:ByteArray = new ByteArray();
			
			ba.writeUnsignedInt(fileType);
			ba.writeUnsignedInt(fileId);
			ba.writeUTF(fileName);
			ba.writeUnsignedInt(isGroup);
			ba.writeUnsignedInt(isCompress);
			ba.writeUnsignedInt(compressType);
			ba.writeUnsignedInt(groupType);
			ba.writeBytes(fileBa);
			
			var tempBa:ByteArray = new ByteArray();
			tempBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			tempBa.writeUnsignedInt(ba.length);
			tempBa.writeBytes(ba);
			return tempBa;
		}
		public static function parseFile(f:File):SimpleFileVO{
			var fileVO:SimpleFileVO = new SimpleFileVO();
			var ext:String = String(f.extension).toLowerCase();
			var index:int = FILE_LIST.indexOf(ext);
			var fileType:int = 0;
			switch(index){
				case 0:
					fileType = 1;
					break;
				case 1:
					fileType = 2;
					break;
				case 2:
					fileType = 4;
					break;
				case 3:
					fileType = 3;
					break;
				case 4:
					fileType = 5;
					break;
				case 5:
					fileType = 7;
					break;
			}
			fileVO.fileType = fileType;
			fileVO.fileName = f.name;
			fileVO.isCompress = 2;
			fileVO.compressType = 0;
			fileVO.groupType = 1;
			var ba:ByteArray = FilePackManager.getInstance().getFileData(f);
			ba.position = 0;
			var isEn:Boolean = FilePackManager.getInstance().isEncode(ba);
			if(isEn){
				return null;
			}
		
			fileVO.fileBa = ba;
			fileVO.fileId = AnimationPackager.getInstance().fileId++;
			return fileVO;
		}
		
	}
}