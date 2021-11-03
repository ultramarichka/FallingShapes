package model;

//MODEL
class Model {
    public var numberOfShapes:Int;
    public var summaryArea:Int;
    public var gravity:Float;
    public var shapes:Array<String>;
    public var colors:Array<Int>;
    public var data:Dynamic;

    public function new(?numberOfShapes:Int, ?summaryArea:Int)
    {
        this.data = { 
            numberOfShapes : 0,
            summaryArea: 0,
            gravity : 0.005,
            shapes : ["circle", "elipse", "triangle", "square", "pentagon", "hexagon", "star"],
            colors : [0xff0000, 0x00ff00, 0x0000ff, 0x00ffff, 0xffff00]
        };
    }
}