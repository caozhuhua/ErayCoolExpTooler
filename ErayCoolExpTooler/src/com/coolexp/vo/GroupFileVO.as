package com.coolexp.vo
{
	import flash.utils.ByteArray;

	public class GroupFileVO extends BaseFileVO
	{
		public function GroupFileVO()
		{
		}
		
		public var fileNum:int;
		public var fileList:Array=[];
		override public function toByteArray():ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.writeUnsignedInt(fileType);
			ba.writeUnsignedInt(fileId);
			ba.writeUTF(fileName);
			ba.writeUnsignedInt(isGroup);
			ba.writeUnsignedInt(fileNum);
			for(var i:int = 0;i<fileNum;++i){
				var byteArray:ByteArray = null;
				if(fileList[i] is ByteArray){
					byteArray = ByteArray(fileList[i]);
				}else{
					var simpleFileVO:SimpleFileVO = fileList[i] as SimpleFileVO;
					byteArray = simpleFileVO.toByteArray();
				}
				ba.writeUnsignedInt(byteArray.length);
				ba.writeBytes(byteArray);
			}
			var tempBa:ByteArray = new ByteArray();
			tempBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			tempBa.writeUnsignedInt(ba.length);
			tempBa.writeBytes(ba);
			return tempBa;
		}
		public static function parseFile(fileName:String,fileId:int,fileType:int,fileList:Array):GroupFileVO{
			var g:GroupFileVO = new GroupFileVO();
			g.fileName = fileName;
			g.fileId = fileId;
			g.fileType = fileType;
			g.fileNum = fileList.length;
			g.fileList = fileList;
			g.isGroup = FileTypeVO.IS_GROUP;
			return g;
		}
	}
}