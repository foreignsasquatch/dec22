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

    camera = Rl.Camera2D.create(Rl.Vector2.zero(), Rl.Vector2.create(x, y), 0, 4);

    texture_width = 13;
    texture_height = 15;

    friction_x = 0.82;
    friction_y = 0.9;
  }

  override function update() {
    // idle animation
    if(velocity_x == 0 && velocity_y == 0) {
    }

    // Movement
    if(Rl.isKeyDown(input.LEFT)) {
      velocity_x = -0.25;
      texture_width = -13;
    }
    if(Rl.isKeyDown(input.RIGHT)) {
      velocity_x = 0.25;
      texture_width = 13;
    }

    // jump
    if(is_on_floor && Rl.isKeyPressed(input.JUMP)) {
      // jumping stretch
      setSquashX(0.5);
      velocity_y = -0.5;
    }

    // landing squash
    if(is_on_floor) {
      if(is_just_on_floor) {
        setSquashY(0.7);
        is_just_on_floor = false;
      }
    } else {
      if(!is_just_on_floor) {
        is_just_on_floor = true;
      }
    }

    // gravity
    velocity_y += 0.03;

    super.update();
  }

  override function draw() {
    super.draw();
  }
}