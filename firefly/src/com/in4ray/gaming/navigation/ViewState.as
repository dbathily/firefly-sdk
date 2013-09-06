// =================================================================================================
//
//	in4ray Gaming SDK
//	Copyright 2013 in4ray. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package com.in4ray.gaming.navigation
{
	import com.in4ray.gaming.components.Sprite;
	import com.in4ray.gaming.consts.CreationPolicy;
	import com.in4ray.gaming.layouts.$height;
	import com.in4ray.gaming.layouts.$width;
	import com.in4ray.gaming.texturers.TextureState;

	[ExcludeClass]
	/**
	 * View state value object 
	 */	
	public class ViewState
	{

		public function ViewState(viewClass:Class = null, popUp:Boolean = false, name:String = "", properties:Object = null, textureState:TextureState = null, creaionPolicy:String = CreationPolicy.ONDEMAND)
		{
			this.popUp = popUp;
			this.name = name;
			this.creaionPolicy = creaionPolicy;
			this.textureState = textureState;
			this.viewClass = viewClass;
			this.properties = properties;

			if(creaionPolicy == CreationPolicy.INIT)
				getView(properties);
		}
		
		public var viewClass:Class;
		public var textureState:TextureState;
		private var view:Sprite;
		public var creaionPolicy:String;
		public var name:String;
		public var popUp:Boolean;
        public var properties:Object;

		public function getView(properties:Object):Sprite
		{
			var viewInstance:Sprite;
			
			if(!view)
			{
				viewInstance = new viewClass();
				if(viewInstance.getLayouts().length == 0)
					viewInstance.addLayout($width(100).pct, $height(100).pct);

                var p:Object = properties ? properties : this.properties;

                if(p)
                {
                    for(var property:String in p)
                    {
                        viewInstance[property] = p[property];
                    }
                }

				if(creaionPolicy != CreationPolicy.NOCACHE)
					view = viewInstance;
			}
			else
			{
				viewInstance = view;
			}
			
			return viewInstance;
		}
	}
}