package com.coolexp.vo
{
	public class XMLItemVO
	{
		public function XMLItemVO()
		{
		}
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _frameX:Number;
		private var _frameY:Number;
		private var _frameWidth:Number;
		private var _frameHeight:Number;
		
		public function get frameHeight():Number
		{
			return _frameHeight;
		}
		
		public function set frameHeight(value:Number):void
		{
			_frameHeight = value;
		}
		
		public function get frameWidth():Number
		{
			return _frameWidth;
		}
		
		public function set frameWidth(value:Number):void
		{
			_frameWidth = value;
		}
		
		public function get frameY():Number
		{
			return _frameY;
		}
		
		public function set frameY(value:Number):void
		{
			_frameY = value;
		}
		
		public function get frameX():Number
		{
			return _frameX;
		}
		
		public function set frameX(value:Number):void
		{
			_frameX = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public static function parseXML(node:XML):XMLItemVO{
			var obj:XMLItemVO = new XMLItemVO();
			obj.x = Number(node.@x);
			obj.y = Number(node.@y);
			obj.width = Number(node.@width);
			obj.height = Number(node.@height);
			obj.frameX = Number(node.@frameX);
			obj.frameY = Number(node.@frameY);
			obj.frameWidth = Number(node.@frameWidth);
			obj.frameHeight = Number(node.@frameHeight);
			return obj;
		}
	}
}