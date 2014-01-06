package com.coolexp.vo
{
	public class KeyVO
	{
		public function KeyVO()
		{
		}
		public var key_1:int;
		public var key_2:int;
		public static function create(k1:int,k2:int):KeyVO{
			var keyVO:KeyVO = new KeyVO();
			keyVO.key_1 = k1;
			keyVO.key_2 = k2;
			return keyVO;
		}
	}
}