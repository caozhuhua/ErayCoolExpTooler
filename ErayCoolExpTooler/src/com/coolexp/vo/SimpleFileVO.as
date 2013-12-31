package com.coolexp.vo
{
	import flash.utils.ByteArray;

	public class SimpleFileVO extends BaseFileVO
	{
		
		
		public function SimpleFileVO()
		{
		}
		public var isCompress:int;
		public var compressType:int;
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
	}
}