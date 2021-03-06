// =================================================================================================
//
//	in4ray Gaming SDK
//	Copyright 2013 in4ray. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package spark.core 
{
	import com.in4ray.gaming.components.flash.Sprite;
	
	/**
	 * FXG display object. 
	 */	
	public class SpriteVisualElement extends Sprite
	{
		/**
		 * Original height of FXG. 
		 */		
		public var viewHeight:Number;
		
		/**
		 * Original width of FXG. 
		 */	
		public var viewWidth:Number;
		
		/**
		 * Constructor. 
		 */		
		public function SpriteVisualElement() 
		{
			super();
		}
			
		/**
		 * @inheritDoc 
		 */		
		override public function setActualSize(w:Number, h:Number):void
		{
			super.setActualSize(w, h);
			
			scaleX = scaleY = Math.max(width/viewWidth, height/viewHeight);
		}
	}
}