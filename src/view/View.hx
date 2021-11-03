package view;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.display.Shape;
import controller.Controller;

//VIEW
class View extends Sprite {
    private var controller:Controller;
	private var howManyMiliSeconds:Int;

	private var rect:RectContainer;
	private var contX:Int;
	private var contY:Int;
	private var containerWidth:Int;
	private var containerHeight:Int;
	private var maskHeight:Int = 100;

	private var flag:Bool = true;

	private var numberOfShapesText:TextShapes;
	private var sumAreaText:TextShapes;

	private var iName:Int;
	private var iColor:Int;

    private var numberOfShapesView:Int;
    private var summaryArea:Int;
    private var gravityView:Float;
    private var shapes:Array<String>;
    private var colors:Array<Int>;
	public var dataView:Dynamic;
	private var previousUpdateTime:Float; 

	public function new(controller) {
		super();
		this.controller = controller;
        init();
	}

	public function init(){
		var stage = new Stage(1600, 800, 0xffffff);
        js.Browser.document.body.appendChild(stage.element);

		containerWidth = 800;
		containerHeight = Math.round(stage.stageHeight);
		contX = Math.round((stage.stageWidth - containerWidth) / 2);
		contY = 0;

		rect = new RectContainer(contX, contY, containerWidth, containerHeight, 0xffffff);
		stage.addChild(rect);

		// add MASK
		var maskTop = new Sprite();
		maskTop.graphics.beginFill(0xffffff);
		maskTop.graphics.drawRect(contX, contY, containerWidth, maskHeight);
		stage.addChild(maskTop);

		var maskBottom = new Sprite();
		maskBottom.graphics.beginFill(0xffffff);
		maskBottom.graphics.drawRect(contX, containerHeight - maskHeight, containerWidth, maskHeight);
		stage.addChild(maskBottom);

		var maskLeft = new Sprite();
		maskLeft.graphics.beginFill(0xffffff);
		maskLeft.graphics.drawRect(0, 0, (stage.stageWidth - containerWidth) / 2, containerHeight);
		stage.addChild(maskLeft);

		var maskRight = new Sprite();
		maskRight.graphics.beginFill(0xffffff);
		maskRight.graphics.drawRect(contX + containerWidth, 0, (stage.stageWidth - containerWidth) / 2, containerHeight);
		stage.addChild(maskRight);

		// add FRAME
		var frame = new Shape();
		frame.graphics.lineStyle(1, 0x000000);
		frame.graphics.moveTo(contX, maskHeight);
		frame.graphics.lineTo(contX + containerWidth, maskHeight);
		frame.graphics.lineTo(contX + containerWidth, containerHeight - maskHeight);
		frame.graphics.lineTo(contX, containerHeight - maskHeight);
		frame.graphics.lineTo(contX, maskHeight);
		stage.addChild(frame);  

		// TEXT
		var textWidth1 = 250;
		var textWidth2 = 350;
		var textHeight = 30;
		numberOfShapesText = new TextShapes(contX, maskHeight - textHeight, textWidth1, textHeight, "<div>Number of shapes: </div>");
		stage.addChild(numberOfShapesText);

		sumAreaText = new TextShapes(contX + textWidth1, maskHeight - textHeight, textWidth2, textHeight, "<div>Surface area occupied by shapes: </div>");
		stage.addChild(sumAreaText);

		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);

	}

	public function render(data):Void
	{
		numberOfShapesView = data.numberOfShapes; 
		summaryArea = data.summaryArea; 
		gravityView = data.gravity;
		shapes = data.shapes; 
		colors = data.colors; 

		dataView = {
			numberOfShapes: data.numberOfShapes,
			summaryArea: data.summaryArea,
			gravity: data.gravity,
			shapes : data.shapes,
            colors : data.colors
		};

		previousUpdateTime = Date.now().getTime();

		rect.addEventListener(MouseEvent.MOUSE_DOWN, addNewShapeToContainer);
		rect.addEventListener(MouseEvent.MOUSE_UP, freeFlag);
	}

	private function createShape(x:Int, y:Int, shape:String):Dynamic 
	{
		var fallingShape = new FallShape(shape, colors[iColor]);
		
		fallingShape.x = x;
		fallingShape.y = y;

		//randomize speed of the shape
		fallingShape.speedY = 0.001*Math.random();

		rect.addChild(fallingShape);

		fallingShape.addEventListener(MouseEvent.MOUSE_DOWN, removeShape);
		fallingShape.addEventListener(MouseEvent.MOUSE_UP, freeFlag);

		// Update SUM AREA px2
		var shapeArea = calcShapeArea(fallingShape);
		return calcSumArea(shapeArea);
	}

	
	//calculate area occupied by the shape
	private function calcShapeArea(figure:FallShape): Int
	{
		var shapeArea = 0;
		if(figure.area != 0){
			shapeArea = figure.area;
		} else {
			var boundingBox = figure.getBounds(rect);
			var xBB = Math.round(boundingBox.x);
			var widthBB = Math.round(boundingBox.width);
			var yBB = Math.round(boundingBox.y);
			var heightBB = Math.round(boundingBox.height);
	
			var x:Int = xBB;
			for (x in xBB...(xBB + widthBB)) {
				var y:Int = yBB;
					for (y in yBB...(yBB + heightBB)) {
					if (figure.hitTestPoint(x, y, true)) {
						shapeArea += 1;
					}
				}
			}	
			figure.area = shapeArea;
		}

		return shapeArea;
	}
	
	//calculate summary area occupied by shapes
	private function calcSumArea(shapeArea:Int):Int
	{
		summaryArea += shapeArea;

		numberOfShapesText.htmlText = "<div>Number of shapes: </div>";
		numberOfShapesText.appendText(Std.string(rect.numChildren));

		sumAreaText.htmlText = "<div>Surface area occupied by shapes: </div>";
		sumAreaText.appendText(Std.string(summaryArea) + " px2");

		dataView = updateDataView(rect.numChildren, summaryArea);
		return dataView;
	}
	
	private function calcMinusArea(figure:FallShape):Int{
		var shapeArea = 0;
		shapeArea = figure.area;
		summaryArea -= shapeArea;
		sumAreaText.htmlText = "<div>Surface area occupied by shapes: </div>";
		sumAreaText.appendText(Std.string(summaryArea) + " px2");

		//remove Shape
		figure.removeEventListener(MouseEvent.MOUSE_DOWN, removeShape);
		rect.removeChild(figure);
		//update Number of Shapes
		numberOfShapesText.htmlText = "<div>Number of shapes: </div>";
		numberOfShapesText.appendText(Std.string(rect.numChildren));

		dataView = updateDataView(rect.numChildren, summaryArea);
		return dataView;
	}

	public function updateDataView(numbS:Int, area:Int, ?gravityView:Float):Dynamic
	{
		dataView.numberOfShapes = numbS;
		dataView.summaryArea = area;
		dataView.gravity = gravityView;
		return dataView;
	}

    // Event Handlers
	// move shapes
	private function stage_onEnterFrame(event:Event):Void {
		var time = Date.now().getTime();
		if (time - previousUpdateTime > 1000){
			iName = Math.round(Math.random() * (shapes.length - 1));
			iColor = Math.round(Math.random() * (colors.length - 1));
	
			// initial coordinates of SHAPE
			var xTop = Math.round(contX + Math.random() * (containerWidth - 100));
			var yTop = contY;
			dataView = createShape(xTop, yTop, shapes[iName]);
			this.controller.setData(dataView);

			previousUpdateTime = time;
		}
		
		var rectNumChildren:Int = rect.numChildren;
		var i:Int = 0;
		for (i in 0...rectNumChildren) {
			var figure = cast(rect.getChildAt(i), FallShape);
			figure.y += figure.speedY;
			figure.speedY += gravityView;

			if (figure.y >= containerHeight - maskHeight) {
				//update Summary Area & Update Number of Shapes
				calcMinusArea(figure);
				break;
			}
		}
	}

	private function addNewShapeToContainer(event:MouseEvent):Void {
		if (flag) {
			var clickedX:Int = Math.round(event.localX - 50);
			var clickedY:Int = Math.round(event.localY - 50);
			createShape(clickedX, clickedY, "random");
			flag = false;
		}
	}

	private function freeFlag(event:MouseEvent):Void {
		flag = true;
	}

	private function removeShape(e:Dynamic):Void {
		if (flag) {
			//update Summary Area & Update Number of Shapes
			calcMinusArea(e.target);			
			flag = false;
		}
	}
}