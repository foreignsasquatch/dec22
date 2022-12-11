package en;

class Rocket extends Entity {
  public function new(x:Int, y:Int, map:ldtk.Layer_Tiles) {
    super(map);

    sprite = Aseprite.loadAsepriteToTexture("res/player_a.aseprite");
    setCoords(x, y);
  }

  override function update() {
    if(Rl.isKeyDown(Rl.Keys.W)) dy  = -0.5;
    if(Rl.isKeyDown(Rl.Keys.DOWN)) dy  = 0.5;

    dx += 0.03;

    super.update();
  }
}