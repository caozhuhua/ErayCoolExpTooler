package com.coolexp.vo
{
	import flash.utils.ByteArray;

	public class BaseFileVO
	{
		
		public static const fileHeadStrLength:int = 9;
		public static const FILE_HEAD_STR:String = "ERAYGAMES";
		public var fileHeadString:String;
		public var fileLength:int;
		/**
		 *1,代表swf,2代表sound3,JPG文件4,PNG文件,5代码XML7,代表DAT二进制 11.eray后缀名文件  20，edat文件，21，XML+PNG动画文件26,erayswf文件，27,初始化文件组合, 28,bitmapswf文件
		 */		
		public var fileType:int;
		public var fileId:int;
		public var fileName:String;
		public var fileContent:Object;
		/**
		 *1,为不组合，2为组合 
		 */		
		public var isGroup:int = 1;
		public function toByteArray():ByteArray{
			return null;
		}
		public function BaseFileVO()
		{
		}
		public static function parse(ba:ByteArray):BaseFileVO{
			ba.position = 0;
			var f:BaseFileVO;
			var fileHeadString:String = ba.readUTFBytes(fileHeadStrLength);
			if(fileHeadString==FILE_HEAD_STR){
				var fileLength:int = ba.readUnsignedInt();
				if((fileLength+13)!=ba.length){
					trace("文件长度不对");
					return null;
				}
				var fileType:int = ba.readUnsignedInt();
				var fileId:int = ba.readUnsignedInt();
				var fileName:String = ba.readUTF();
				var isGroup:int = ba.readUnsignedInt();
				if(isGroup==1){
					var fid:SimpleFileVO = new SimpleFileVO();
					fid.fileHeadString = fileHeadString;
					fid.fileLength = fileLength;
					fid.fileType = fileType;
					fid.fileId = fileId;
					fid.fileName =fileName;
					fid.isGroup = isGroup;
					fid.isCompress = ba.readUnsignedInt();
					fid.compressType = ba.readUnsignedInt();
					fid.groupType = ba.readUnsignedInt();
					fid.fileBa = new ByteArray();
					ba.readBytes(fid.fileBa);
					f = fid;
				}else{
					var gfd:GroupFileVO = new GroupFileVO();
					gfd.fileHeadString = fileHeadString;
					gfd.fileLength = fileLength;
					gfd.fileType = fileType;
					gfd.fileId = fileId;
					gfd.fileName =fileName;
					gfd.isGroup = isGroup;
					gfd.fileNum = ba.readUnsignedInt();
					for(var i:int = 0,l:int = gfd.fileNum;i<l;i++){
						var fileLengthss:int = ba.readUnsignedInt();
						var fileData:ByteArray = new ByteArray();
						ba.readBytes(fileData,0,fileLengthss);
						fileData.position = 0;
						var ffdd:BaseFileVO = BaseFileVO.parse(fileData);
						gfd.fileList.push(ffdd);
					}
					f = gfd;
				}
			}else{
				var originalFile:SimpleFileVO = new SimpleFileVO();
				ba.position = 0;
				originalFile.fileContent = ba;
				f = originalFile;
			}
			return f;
		}
	}
}