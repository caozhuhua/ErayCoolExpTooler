package com.coolexp.events
{
	import flash.events.Event;
	
	public class ActionEvent extends Event
	{
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public static const DELETE_ITEM_EVENT:String = "delete_item_event";
		public static const ADD_ITEM_EVENT:String = "add_item_event";
		public static const CHECK_SOFT_EVENT:String = "check_soft_event";
		public static const SEE_NODE_ANI_EVENT:String = "see_node_ani_event";
		public var key:String;
		public var blood:String;
		public var result:int;
	}
}