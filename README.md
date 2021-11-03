## Getting started

1. Clone the repository
```
git clone https://github.com/ultramarichka/FallingShapes.git
```
2. Install all dependencies
```
npm install
```
3. Build the project and open ```index.html``` file in browser
```
npm start
```

## Some additional explanations

* ```npm``` has to be previously installed.
* As seen on the screenshot while adding *OpenFL* ```dist/``` folder is created *with ```index.html```* inside.
  Thus it is necessary to have it in the git repository.
  ![install openfl](/dist/assets/yo_openfl.png) 
  ```
  npm install yo generator-openfl
  yo openfl
  ```
  

* **About summary area occupied by shapes calculations**
  First time I've counted the summary area inside the frame using **hitTestPoint** by all x,y inside the frame.
  That was quite slow. So I've made some kind of optimization counting summary area by calculating *only figure's area inside it's bounding box*
  at the time the shape was created ( shape is behind the top mask )... I was going to *calculate intersaction* of it and the frame (or the mask)
  at the time the shape starts to appear on the 'screen'. Also I was going to subtract extra intersections area between the shapes. 
  But that would make calculations even slower. So I decided to calculate area of all predicted(in ```class FallingShape```) shapes in advance. 
  Another variant came to my mind - make a **Bitmap** of the space inside the frame and count white pixels of the "screen"...if possible. Haven't tried it yet.

## Working 'Falling Shapes' game
  ![falling shapes gif](/dist/assets/falling_shapes.gif) 
