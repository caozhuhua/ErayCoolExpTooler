package com.coolexp.vo
{
	public class FileTypeVO
	{
		public function FileTypeVO()
		{
		}
		//1,代表swf,2代表sound3,JPG文件4,PNG文件,5代码XML7,代表DAT二进制 11.eray后缀名文件  20，edat文件，21，XML+PNG动画文件26,erayswf文件，27,初始化文件组合 28,bitmapswf
		public static const SWF_TYPE:int = 1;
		public static const MP3_TYPE:int = 2;
		public static const JPG_TYPE:int = 3;
		public static const PNG_TYPE:int = 4;
		public static const XML_TYPE:int = 5;
		public static const DAT_TYPE:int = 7;
		public static const ERAY_TYPE:int = 11;
		public static const EDAT_TYPE:int = 20;
		public static const ANI_1_TYPE:int = 21;
		public static const ANI_2_TYPE:int = 26;
		public static const GAME_G_TYPE:int = 27;
		public static const ANI_3_TYPE:int = 28;
		
		
		/**
		 *组合文件 
		 */		
		public static const IS_GROUP:int = 2;
		public static const NO_GROUP:int = 1;
		
	}
}