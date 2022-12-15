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

    super.update();
  }
}