import openfl.Vector;
import openfl.display.Sprite;
import openfl.display.*;

class FallShape extends Sprite
{
	public var speedY:Float = 0.00001;
	public var area:Int = 0;

	public function new(name:String, color:Int)
	{
		super();

		var size = 100;
		// r = size/2
		var r = 50; 

		this.name = name;

		switch (name)
		{
			case "circle":
				this.graphics.beginFill(color);
				this.graphics.lineStyle(1, 0x000000);
				this.graphics.drawCircle(size / 2, size / 2, size / 2);
				this.area = Math.round(Math.PI * size /2* size/2);

			case "elipse":
				this.graphics.beginFill(color);
				this.graphics.lineStyle(1, 0x000000);
				this.graphics.drawEllipse(0, 0, 1.5 * size, size);
				this.area = Math.round(Math.PI * 1.5* size /2* size/2);

			case "triangle":
				prepareShape(3, r, color);

			case "square":
				prepareShape(4, r, color);
	
			case "pentagon":
			    prepareShape(5, r, color);

			case "hexagon":
				prepareShape(6, r, color);

			case "star":
				prepareShape(5, r, color);

			case "random":
				var max = 12;
				var min = 3;
				var randomAngles = Math.round(Math.random() * (max - min) + min);
				prepareShape(randomAngles, r, color);

			default:
				prepareShape(3, r, color);
		}
	}

	public function prepareShape(howManyAngles:Int, r:Int, color:Int):Int
	{
		var polygon = [];
		var n:Int;
		var vertex:Int;
		var coordinates:Int;

		if(this.name == "star"){
			vertex = 10;
			coordinates = 20;
		} else {
			vertex = howManyAngles;
			coordinates = 2*howManyAngles;
		}

		var polygonCommands = new Vector<Int> (vertex, true);

		polygonCommands[0] = GraphicsPathCommand.MOVE_TO;
		for(n in 1...vertex){
			polygonCommands[n] = GraphicsPathCommand.LINE_TO;
		}

		var polygonCoord = new Vector<Float> (coordinates, true);

		for (n in 0...howManyAngles){
			polygon.push(Math.round(r*Math.cos((90 - 180+n*360/howManyAngles)*Math.PI/180)) + r);
			polygon.push(Math.round(r*Math.sin((90 - 180+n*360/howManyAngles)*Math.PI/180)) + r);	

			if(this.name == "star"){
				// 90 + 72/2 = 126
				polygon.push(Math.round(r/3*Math.cos((126 - 180+n*360/howManyAngles)*Math.PI/180)) + r);
				polygon.push(Math.round(r/3*Math.sin((126 - 180+n*360/howManyAngles)*Math.PI/180)) + r);
			}
		}	

		var i:Int = 0;
		for(i in 0...coordinates){
			polygonCoord[i] = polygon[i];
		}
		
		this.graphics.beginFill(color);
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.drawPath(polygonCommands, polygonCoord);
		this.graphics.lineTo(r, 0);

		//center is in the (r,r)
		if(this.name != "star"){
			this.area = Math.round(1/2 * howManyAngles * r*r* Math.sin(360/howManyAngles*Math.PI/180));
		}

		return this.area;
	}
}
