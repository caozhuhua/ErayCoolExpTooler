package com.coolexp.manager
{
	import com.coolexp.vo.NodeVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class DataModel extends EventDispatcher
	{
		private static var _instance:DataModel;
		public function DataModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():DataModel{
			if(_instance==null){
				_instance = new DataModel();
			}
			return _instance;
		}
		public var nodeList:ArrayCollection;
		
		public function convertListToXML():XML{
			var xml:XML = null;
			if(nodeList){
				var xmlString:String = "<nodes>";
				for(var i:int = 0,l:int = nodeList.length;i<l;++i){
					var nodeVO:NodeVO = nodeList.getItemAt(i) as NodeVO;
					xmlString+='<node blood="'+nodeVO.blood+'" key="'+nodeVO.key+'"/>'
				}
				xmlString+='</nodes>';
				xml = new XML(xmlString);
			}
			return xml;
		}
	}
}