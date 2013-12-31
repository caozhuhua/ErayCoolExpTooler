package com.coolexp.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="delete_item_event", type="com.coolexp.events.ActionEvent")]
	[Event(name="add_item_event", type="com.coolexp.events.ActionEvent")]
	[Event(name="see_node_ani_event", type="com.coolexp.events.ActionEvent")]
	public class EventManager extends EventDispatcher
	{
		private static var _instance:EventManager;
		public function EventManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():EventManager{
			if(_instance==null){
				_instance = new EventManager();
			}
			return _instance;
		}
	}
}