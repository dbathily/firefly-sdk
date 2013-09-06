// =================================================================================================
//
//	in4ray Gaming SDK
//	Copyright 2013 in4ray. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package com.in4ray.gaming.transitions
{
	import com.in4ray.gaming.effects.IAnimation;
	import com.in4ray.gaming.effects.Parallel;
import com.in4ray.gaming.navigation.View;
import com.in4ray.gaming.navigation.ViewState;

	/**
	 * Transition that plays parallel animations for from and to state while transiting.  
	 */	
	public class ParallelTransition extends BasicTransition
	{
		/**
		 * Constructor.
		 *  
		 * @param trigger Event trigger.
		 * @param fromState Transition from state.
		 * @param toState Tarnsition to state.
		 * @param fromAnimation Animation for FROM state view.
		 * @param toAnimation Animation for TO state view.
		 */		
		public function ParallelTransition(trigger:String, fromState:String="*", toState:String="*", fromAnimation:IAnimation = null, toAnimation:IAnimation = null)
		{
			super(trigger, fromState, toState);
			
			this.toAnimation = toAnimation;
			this.fromAnimation = fromAnimation;
		}
		
		/**
		 *  Animation for FROM state view.
		 */		
		public var fromAnimation:IAnimation;

		/**
		 * Animation for TO state view. 
		 */		
		public var toAnimation:IAnimation;
		
		/**
		 * @private 
		 */		
		protected var parallel:Parallel;
		
		/**
		 * Duration of animations in milliseconds. 
		 */		
		public var duration:Number;
		
		protected var _isPlaying:Boolean;
		
		/**
		 * @inheritDoc 
		 */		
		override public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function play(fromView:View, toView:View, callBack:Function=null, ...params):void
		{
			_fromView = fromView;
			_toView = toView;
			
			this.callBack = callBack;
			this.params = params;
			
			_isPlaying = true;
			
				
			dispatchRemoving();
			if(_toView)
				_navigator.textureManager.switchToState(_toView.state.textureState);
			_navigator.showView(_toView);
			dispatchAdding();
				
			var animations:Array = [];
			if(fromAnimation && fromView)
			{
				fromAnimation.target = fromView.view;
				animations.push(fromAnimation);
			}
			if(toAnimation && toView)
			{
				toAnimation.target = toView.view;
				animations.push(toAnimation);
			}
			
			if(animations.length > 0)
			{
				parallel = new Parallel(null, duration, animations);
				parallel.completeCallback = animationComplete;
				parallel.disposeOnComplete = true;
				playParallel();
			}
			else
			{
				animationComplete();
			}
		}
		
		/**
		 * @private 
		 */
		protected function playParallel():void
		{
			parallel.play();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function end():void
		{
			if(parallel)
			{
				parallel.end();
			}
		}
		
		/**
		 * @private 
		 */
		protected function animationComplete():void
		{
			_isPlaying = false;
			
			_navigator.hideView(_fromView);
			_navigator.showView(_toView);
			dispatchRemoved();
			dispatchAdded();
			
			invokeCallback();
		}
	}
}