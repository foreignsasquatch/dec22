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

    if(collision_layer.isCoordValid(cell_x,cell_y) && collision_layer.hasAnyTileAt(cell_x,cell_y) && cell_ratio_x >= 0.25) {
      cell_ratio_x = 0.25;
      velocity_x = 0;

      is_colliding = true;
    } else {
      is_colliding = false;
    }

    // if(collision_layer.isCoordValid(cell_x - 1,cell_y) && collision_layer.hasAnyTileAt(cell_x - 1,cell_y) && cell_ratio_x <= 0.25) {
    //   cell_ratio_x = 0.25;
    //   velocity_x = 0;
    
    //   is_colliding = true;
    // } else {
    //   // is_colliding = false;
    // }

    while(cell_ratio_x > 1) {
      cell_ratio_x--; cell_x++;
    }
    while(cell_ratio_x < 0) {
      cell_ratio_x++; cell_x--;
    }

    cell_ratio_y += velocity_y;
    velocity_y *= friction_y;

    // top
    if(collision_layer.isCoordValid(cell_x,cell_y) && collision_layer.hasAnyTileAt(cell_x,cell_y) && cell_ratio_y <= 0.25) {
      cell_ratio_y = 0.25;
      velocity_y = 0;

      is_colliding = true;
    } else {
      // is_colliding = false;
    }

    // bottom
    // if(collision_layer.isCoordValid(cell_x,cell_y + 1) && collision_layer.hasAnyTileAt(cell_x,cell_y + 1) && cell_ratio_y >= 0.25) {
    //   cell_ratio_y = 0.25;
    //   velocity_y = 0;

    //   is_on_floor = true;
    //   is_colliding = true;
    // } else {
    //   is_on_floor = false;
    //   // is_colliding = false;
    // }

    while(cell_ratio_y > 1) {
      cell_ratio_y--;cell_y++;
    }
    while(cell_ratio_y < 0) {
      cell_ratio_y++;cell_y--;
    }

    x = (cell_x + cell_ratio_x) * 16;
    y = (cell_y + cell_ratio_y) * 16;

    if(is_colliding) {
      color = Rl.Colors.RED;
    } else {
      color = Rl.Colors.WHITE;
    }
  }

  var color = Rl.Colors.WHITE;
  override function draw() {
    var size = 16;

    var width_visual = size * squash_x;
    var width_difference = size - width_visual;
    var x_offset = x + (width_difference / 2);

    var height_visual = size * squash_y;
    var width_difference_y = size - height_visual;
    var y_offset = y + (width_difference_y / 2);

    // Rl.drawTexture(texture, Std.int(x), Std.int(y), Rl.Colors.WHITE);
    Rl.drawTexturePro(texture, Rl.Rectangle.create(texture_x_incr * 16, texture_y_incr * 16, texture_width, texture_height), Rl.Rectangle.create(x_offset, y_offset, 16 * squash_x, 16 * squash_y), Rl.Vector2.create(0, 0), 0, color);

    squash_x += (1 - squash_x) * Math.min(1, 0.2 * 0.6);
    squash_y += (1 - squash_y) * Math.min(1, 0.2 * 0.6);
  }
}