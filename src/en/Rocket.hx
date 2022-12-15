package en;

import rx.aseprite.Loader;

class Rocket extends rx.Entity {
  public function new(x:Float, y:Float, l:ldtk.Layer_Tiles) {
    super(x, y, l);

    texture = Loader.loadTexture("res/rocket.aseprite");
    setCoords(x, y);
  }

  override function update() {
    if(Rl.isKeyDown(Rl.Keys.W)) velocity_y  = -0.1;
    if(Rl.isKeyDown(Rl.Keys.DOWN)) velocity_y  = 0.1;

    velocity_x = 0.1;

    cell_ratio_x += velocity_x;
    velocity_x *= friction_x;

    if(collision_layer.isCoordValid(cell_x + 1,cell_y) && collision_layer.hasAnyTileAt(cell_x + 1,cell_y) && cell_ratio_x >= 0.5) {
      cell_ratio_x = 0.5;
      velocity_x = 0;

      is_colliding = true;
    } else {
      is_colliding = false;
    }

    if(collision_layer.isCoordValid(cell_x - 1,cell_y) && collision_layer.hasAnyTileAt(cell_x - 1,cell_y) && cell_ratio_x <= 0.5) {
      cell_ratio_x = 0.5;
      velocity_x = 0;
    
      is_colliding = true;
    } else {
      // is_colliding = false;
    }

    while(cell_ratio_x > 1) {
      cell_ratio_x--; cell_x++;
    }
    while(cell_ratio_x < 0) {
      cell_ratio_x++; cell_x--;
    }

    cell_ratio_y += velocity_y;
    velocity_y *= friction_y;

    // top
    if(collision_layer.isCoordValid(cell_x,cell_y - 1) && collision_layer.hasAnyTileAt(cell_x,cell_y - 1) && cell_ratio_y <= 0.5) {
      cell_ratio_y = 0.5;
      velocity_y = 0;

      is_colliding = true;
    } else {
      // is_colliding = false;
    }

    // bottom
    if(collision_layer.isCoordValid(cell_x,cell_y + 1) && collision_layer.hasAnyTileAt(cell_x,cell_y + 1) && cell_ratio_y >= 0.5) {
      cell_ratio_y = 0.5;
      velocity_y = 0;

      is_on_floor = true;
      is_colliding = true;
    } else {
      is_on_floor = false;
      // is_colliding = false;
    }

    while(cell_ratio_y > 1) {
      cell_ratio_y--;cell_y++;
    }
    while(cell_ratio_y < 0) {
      cell_ratio_y++;cell_y--;
    }

    x = (cell_x + cell_ratio_x) * 16;
    y = (cell_y + cell_ratio_y) * 16;
  }
}