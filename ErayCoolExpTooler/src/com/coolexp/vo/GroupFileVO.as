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
				var simpleFileVO:SimpleFileVO = fileList[i] as SimpleFileVO;
				var byteArray:ByteArray = simpleFileVO.toByteArray();
				ba.writeUnsignedInt(byteArray.length);
				ba.writeBytes(byteArray);
			}
			var tempBa:ByteArray = new ByteArray();
			tempBa.writeUTFBytes(BaseFileVO.FILE_HEAD_STR);
			tempBa.writeUnsignedInt(ba.length);
			tempBa.writeBytes(ba);
			return tempBa;
		}
	}
}