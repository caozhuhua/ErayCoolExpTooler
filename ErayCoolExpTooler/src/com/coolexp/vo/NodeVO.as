package com.coolexp.vo
{
	import flash.events.EventDispatcher;
	[Bindable]
	public class NodeVO extends EventDispatcher
	{
		public function NodeVO()
		{
		}
		public var from:int;
		public var to:int;
		public var key:String;
		public var blood:String;
		public static function parse(node:XML):NodeVO{
			var nodeVO:NodeVO = new NodeVO();
			nodeVO.from = node.@from;
			nodeVO.to = node.@to;
			nodeVO.key = node.@key;
			nodeVO.blood = node.@blood;
			return nodeVO;
		}
	}
}