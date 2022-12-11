package en;

import rx.aseprite.Loader;
import rx.Entity;

class Player extends Entity {
  public var input:Input;
  public var camera:Rl.Camera2D;

  public var is_just_on_floor = false;

  public function new(x:Float, y:Float, f:String, i:Input, l:ldtk.Layer_Tiles) {
    super(x, y, l);
    input = i;
    texture = Loader.loadTexture(f);

    camera = Rl.Camera2D.create(Rl.Vector2.zero(), Rl.Vector2.create(x, y), 0, 2);
  }

  override function update() {
    // Movement
    if(Rl.isKeyDown(input.LEFT)) velocity_x = -0.5;
    if(Rl.isKeyDown(input.RIGHT)) velocity_x = 0.5;

    // jump
    if(is_on_floor && Rl.isKeyPressed(input.JUMP)) {
      // jumping stretch
      setSquashX(0.5);
      velocity_y = -0.5;
    }

    // landing squash
    if(is_on_floor) {
      if(is_just_on_floor) {
        setSquashY(0.5);
        is_just_on_floor = false;
      }
    } else {
      if(!is_just_on_floor) {
        is_just_on_floor = true;
      }
    }

    // gravity
    velocity_y += 0.02;

    super.update();
  }

  override function draw() {
    super.draw();
  }
}