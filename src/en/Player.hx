package en;

class Player extends Entity {
  public var input:Input;

  public function new(x:Int, y:Int, tex:String, input:Input, map:ldtk.Layer_Tiles) {
    super(map);
    this.input = input;
    sprite = Aseprite.loadAsepriteToTexture(tex);
    setCoords(x, y);
  }

  var justTouchedFloor = false;
  override function update() {
    // Movement
    if(Rl.isKeyDown(input.LEFT)) dx = -0.5;
    if(Rl.isKeyDown(input.RIGHT)) dx = 0.5;
    if(onFloor && Rl.isKeyPressed(input.JUMP)) {
      setSquashX(0.5);
      dy = -0.5;
    }

    if(onFloor) {
      if(justTouchedFloor) {
        setSquashY(0.5);
        justTouchedFloor = false;
      }
    } else {
      if(!justTouchedFloor) {
        justTouchedFloor = true;
      }
    }

    dy += 0.02;

    super.update();
  }

  override function draw() {
    super.draw();
  }
}