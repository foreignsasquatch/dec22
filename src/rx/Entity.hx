package rx;

import ldtk.Layer_Tiles;

class Entity {
  // texture
  public var texture:Rl.Texture;
  public var texture_width:Int = 16;
  public var texture_height:Int = 16;
  public var texture_x_incr:Int = 0;
  public var texture_y_incr:Int = 0;

  // grid coordinates
  public var cell_x:Int;
  public var cell_y:Int;

  // position inside the grid
  public var cell_ratio_x:Float;
  public var cell_ratio_y:Float;

  // resulting coordinates
  public var x:Float;
  public var y:Float;

  public var velocity_x:Float;
  public var velocity_y:Float;

  public var friction_x:Float = 0.98;
  public var friction_y:Float = 0.98;

  public var squash_x = 1.0;
  public var squash_y = 1.0;

  // collision
  public var collision_layer:ldtk.Layer_Tiles;

  // utility 
  public var is_on_floor = false;
  public var is_colliding = false;

  public function new(x:Float, y:Float, layer:ldtk.Layer_Tiles) {
    setCoords(x, y);
    collision_layer = layer;
  }

  public function update() {
    cell_ratio_x += velocity_x;
    velocity_x *= friction_x;

    if(collision_layer.isCoordValid(cell_x + 1,cell_y) && collision_layer.hasAnyTileAt(cell_x + 1,cell_y) && cell_ratio_x >= 0) {
      cell_ratio_x = 0;
      velocity_x = 0;

      is_colliding = true;
    } else {
      is_colliding = false;
    }

    if(collision_layer.isCoordValid(cell_x - 1,cell_y) && collision_layer.hasAnyTileAt(cell_x - 1,cell_y) && cell_ratio_x <= 0) {
      cell_ratio_x = 0;
      velocity_x = 0;
    
      is_colliding = true;
    } else {
      is_colliding = false;
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
    if(collision_layer.isCoordValid(cell_x,cell_y - 1) && collision_layer.hasAnyTileAt(cell_x,cell_y - 1) && cell_ratio_y <= 0) {
      cell_ratio_y = 0;
      velocity_y = 0;

      is_colliding = true;
    } else {
      is_colliding = false;
    }

    // bottom
    if(collision_layer.isCoordValid(cell_x,cell_y + 1) && collision_layer.hasAnyTileAt(cell_x,cell_y + 1) && cell_ratio_y >= 0) {
      cell_ratio_y = 0;
      velocity_y = 0;

      is_on_floor = true;
      is_colliding = true;
    } else {
      is_on_floor = false;
      is_colliding = false;
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

  public function draw() {
    var size = 16;
    
    var width_visual = size * squash_x;
    var width_difference = size - width_visual;
    var x_offset = x + (width_difference / 2);
    
    var height_visual = size * squash_y;
    var width_difference_y = size - height_visual;
    var y_offset = y + (width_difference_y / 2);
    
    // Rl.drawTexture(texture, Std.int(x), Std.int(y), Rl.Colors.WHITE);
    Rl.drawTexturePro(texture, Rl.Rectangle.create(texture_x_incr * 16, texture_y_incr * 16, texture_width, texture_height), Rl.Rectangle.create(x_offset, y_offset, 16 * squash_x, 16 * squash_y), Rl.Vector2.create(0, 0), 0, Rl.Colors.WHITE);
    
    squash_x += (1 - squash_x) * Math.min(1, 0.2 * 0.6);
    squash_y += (1 - squash_y) * Math.min(1, 0.2 * 0.6);
  }

  public function setCoords(x:Float, y:Float) {
    this.x = x;
    this.y = y;
    cell_x = Std.int(x / 16);
    cell_y = Std.int(y / 16);
    cell_ratio_x = (x - cell_x * 16) / 16;
    cell_ratio_y = (y -cell_y * 16) / 16;
  }

  public function setSquashX(scaleX:Float) {
    squash_x = scaleX;
    squash_y = 2 - scaleX;
  }

  public function setSquashY(scaleY:Float) {
    squash_x = 2 - scaleY;
    squash_y = scaleY;
  }
}