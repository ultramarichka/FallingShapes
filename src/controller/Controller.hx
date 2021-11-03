package controller;

import model.Model;
import view.View;

//CONTROLLER
class Controller {
    var model:model.Model;
    var view:view.View;

    public function new(model) { 
        this.view = new View(this);
        this.model = model;
        // this.view = view;
    }

    // public function getData(){
    //     return this.model.data;
    // }

    public function fallShapes():Void{
        this.view.render(this.model.data);

        // new haxe.Timer(1000).run = function() {
        //     trace(this.model.data);
        // }
    }

    public function setData(data){
        this.model.data = data;
    }
}