// =================================================================================================
//
//	in4ray Gaming SDK
//	Copyright 2013 in4ray. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package com.in4ray.gaming.effects
{
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;

	/**
	 * Base class for tween animations. 
	 */	
	public class AnimationBase implements IAnimation
	{
		/**
		 * Constructor.
		 *  
		 * @param target Target of animation.
		 * @param duration Duration in milliseconds.
         * @param useTheJuggler If false, the tween won't be add to the Juggler. You can play the tween manually using {@link advanceTime}
		 */
		public function AnimationBase(target:Object, duration:Number, useTheJuggler:Boolean)
		{
			this.target = target;
			this.duration = duration;
            this.useTheJuggler = useTheJuggler;
		}
		
		private var _tween:Tween;
		
		private var _loop:Boolean = false;

		public function get tween():Tween
		{
			return _tween;
		}

		/**
		 * @inheritDoc 
		 */		
		public function get loop():Boolean
		{
			return _loop;
		}

		public function set loop(value:Boolean):void
		{
			_loop = value;
		}

		private var _delay:Number=NaN;

		/**
		 * @inheritDoc 
		 */
		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
		}

		private var _duration:Number;

		/**
		 * @inheritDoc 
		 */
		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			_duration = value;
		}

		private var _isPlaying:Boolean

		/**
		 * @inheritDoc 
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

        private var _isComplete:Boolean

        /**
         * @inheritDoc
         */
        public function get isComplete():Boolean {
            return _isComplete;
        }
		
		/**
		 * @private
		 */
		private var _juggler:Juggler;

		/**
		 * Animation juggler. 
		 */
		public function get juggler():Juggler
		{
			return _juggler ? _juggler : Starling.juggler;
		}

		public function set juggler(value:Juggler):void
		{
			_juggler = value;
		}

		public function isDefaultJuggler():Boolean
		{
			return _juggler == null;
		}


		/**
		 * Create Tween object. 
		 */		
		protected function createTween():Tween
		{
			var tween:Tween = new Tween(target, (isNaN(duration) ? 1000 : duration)/1000, (transition ? transition : Transitions.LINEAR));
			
			if(!isNaN(delay))
				tween.delay = delay/1000;
            setTweenCallbacks(tween);
			return tween;
		}

        protected function setTweenCallbacks(tween:Tween):void {
            tween.onStart = tweenStart;
            tween.onComplete = tweenComplete;
        }

		/**
		 * Tween animation complete 
		 */		
		protected function tweenComplete():void
		{
			if(loop)
				play();
			else 
			{
                _isComplete = true;

				removeFromJuggler();
				_tween = null;
				if(completeCallback != null)
					completeCallback.apply(null, completeArgs);
				
				if(_disposeOnComplete)
					dispose();
				
				_isPlaying = false;
			}
		}

        /**
         * Tween animation complete
         */
        protected function tweenStart():void
        {
            if(startCallback != null)
                startCallback.apply(null);
        }

        protected function addToJuggler():void {
            if(_useTheJuggler)
                juggler.add(tween);
        }

        protected function removeFromJuggler():void {
            if(_useTheJuggler)
                juggler.remove(tween);
        }

		/**
		 * @inheritDoc 
		 */
		public function play():void
		{
			if(_isPlaying)
				stop();
			
			_tween = createTween();
			addToJuggler();
			_isPlaying = true;
            _isComplete = false;
			onPause = false;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function end():void
		{
			if(_isPlaying)
				stop();
			
			if(completeCallback != null)
				completeCallback.apply(null, completeArgs);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function pause():void
		{
			if(_isPlaying)
			{
				removeFromJuggler();
				_isPlaying = false;
				onPause = true;
			}
		}
		
		private var onPause:Boolean;
		
		/**
		 * @inheritDoc 
		 */
		public function resume():void
		{
			if(onPause)
			{
                addToJuggler();
				_isPlaying = true;
				onPause = false;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function stop():void
		{
			if(_isPlaying)
			{
                removeFromJuggler();
				_isPlaying = false;
				onPause = false;
				if(tween)
					tween.reset(null,0);
				_tween = null;
			}
		}

        /**
         * @inheritDoc
         */
        public function advanceTime(time:Number):void {
            _tween.advanceTime(time);
        }

        private var _target:Object;

        private var _useTheJuggler:Boolean;

		/**
		 * @inheritDoc 
		 */
		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			_target = value;
		}

        public function get useTheJuggler():Boolean {
            return _useTheJuggler;
        }

        public function set useTheJuggler(value:Boolean):void {
            _useTheJuggler = value;
        }

        private var _completeCallback:Function;

		/**
		 * @inheritDoc 
		 */
		public function get completeCallback():Function
		{
			return _completeCallback;
		}

		public function set completeCallback(value:Function):void
		{
			_completeCallback = value;
		}

		private var _completeArgs:Array;
		
		/**
		 * @inheritDoc 
		 */
		public function get completeArgs():Array
		{
			return _completeArgs;
		}
		
		public function set completeArgs(value:Array):void
		{
			_completeArgs = value;
		}

        private var _startCallback:Function;

        /**
         * @inheritDoc
         */
        public function get startCallback():Function
        {
            return _startCallback;
        }

        public function set startCallback(value:Function):void
        {
            _startCallback = value;
        }

        private var _transition:String;
		
		/**
		 * @inheritDoc 
		 */
		public function get transition():String
		{
			return _transition;
		}
		
		public function set transition(value:String):void
		{
			_transition = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function dispose():void
		{
			stop();
			_completeCallback = null;
			_completeArgs = null;
			_target = null;
		}
		
		private var _disposeOnComplete:Boolean;
		
		/**
		 * @inheritDoc 
		 */
		public function get disposeOnComplete():Boolean
		{
			return _disposeOnComplete;
		}

		public function set disposeOnComplete(value:Boolean):void
		{
			_disposeOnComplete = value;
		}

    }
}