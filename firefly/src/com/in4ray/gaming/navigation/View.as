/**
 * User: bathily
 * Date: 06/09/13
 */
package com.in4ray.gaming.navigation {
import com.in4ray.gaming.components.Sprite;

public class View {

    private var _state:ViewState;
    private var _view:Sprite;

    public function View(state:ViewState, view:Sprite) {
        this._state = state;
        this._view = view;
    }

    public function get state():ViewState {
        return _state;
    }

    public function get view():Sprite {
        return _view;
    }
}
}
