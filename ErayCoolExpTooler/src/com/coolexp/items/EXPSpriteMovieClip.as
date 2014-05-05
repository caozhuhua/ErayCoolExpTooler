package com.coolexp.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class EXPSpriteMovieClip extends Sprite
	{
		private var mSource:BitmapData;
		private var mList:Array;
		private var bitmap:Bitmap;
		private var index:int = 0;
		private var _targetPoint:Point;
		private var o:Point = new Point(0,0);
		public function EXPSpriteMovieClip(source:BitmapData,list:Array)
		{
			super();
			init();
			mSource = source;
			mList = list;
		}
		private function init():void{
			bitmap = new Bitmap();
			addChild(bitmap);
		}
		public function render():void{
			if(index>=mList.length){
				index = 0;
			}
			var obj:Object = mList[index];
			index++;
			var bd:BitmapData = new BitmapData(obj.width,obj.height,true,0);
			bd.copyPixels(mSource,new Rectangle(obj.x,obj.y,obj.width,obj.height),o,null,o,true);
			bitmap.bitmapData = bd;
			bitmap.x = Math.abs(obj.frameX);
			bitmap.y = Math.abs(obj.frameY);
		}
	}
}