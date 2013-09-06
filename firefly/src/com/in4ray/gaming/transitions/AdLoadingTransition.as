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
import com.in4ray.gaming.events.ViewEvent;
import com.in4ray.gaming.navigation.View;
import com.in4ray.gaming.navigation.ViewState;

/**
	 * Loading texture with advertisement that will be shown while loading. 
	 */	
	public class AdLoadingTransition extends LoadingTransition
	{

		private var adStates:Array;

		private var randomness:Number;

		private var originalLoadingView:View;
		
		/**
		 * Constructor.
		 *  
		 * @param trigger Trigger event.
		 * @param fromState Transition from state.
		 * @param toState Transition to state.
		 * @param loadingViewState View state that will be shown while transition.
		 * @param adStates List of advertisment view states that will be show randomly while loading.
		 * @param randomness Show advertisment chance (show ad if Math.random() &lt; randomness)
		 */		
		public function AdLoadingTransition(trigger:String, fromState:String, toState:String, loadingViewState:ViewState, adStates:Array, randomness:Number = 0.4)
		{
			super(trigger, fromState, toState, loadingViewState);
			originalLoadingView = loadingView;
			this.randomness = randomness;
			this.adStates = adStates;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function play(fromView:View, toView:View, callBack:Function=null, ...params):void
		{
			loadingView = originalLoadingView;
			if(adStates.length > 0 && Math.random() < randomness)
			{
                var state:ViewState = getAdState();
				loadingView = new View(state, state.getView(null));
				loadingView.view.addEventListener(ViewEvent.CLOSE, adCloseHandler);
			}
			
			super.play.apply(null, [fromView, toView, callBack].concat(params));
		}
		
		/**
		 * @private 
		 */		
		protected function getAdState():ViewState
		{
			if(adStates.length == 1)
				return adStates[0];
			
			return adStates[Math.round(Math.random()*(adStates.length-1))];
		}
		
		/**
		 * @private 
		 */		
		protected function adCloseHandler(event:ViewEvent):void
		{
			loadingView.view.removeEventListener(ViewEvent.CLOSE, adCloseHandler);
			if(textureLoadedFlag)
			{
				super.textureLoaded();
			}
			else
			{
				loadingView = originalLoadingView;
				_navigator.showView(loadingView);
				loadingView.view.dispatchEvent(new ViewEvent(ViewEvent.ADDING_TO_NAVIGATOR));
				loadingView.view.dispatchEvent(new ViewEvent(ViewEvent.ADDED_TO_NAVIGATOR));
			}
		}
		
		private var textureLoadedFlag:Boolean;

		/**
		 * @inheritDoc 
		 */	
		override protected function textureLoaded():void
		{
			textureLoadedFlag = true;
			
			if(loadingView == originalLoadingView)
			{
				super.textureLoaded();
			}
		}
	}
}