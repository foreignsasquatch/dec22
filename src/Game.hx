import level.RocketLevel;
import rx.Application;

class Game extends Application {
  public var rocketLevel:RocketLevel;

  override function init() {
    LargeAssets.load();

    rocketLevel = new RocketLevel();
    current_level = rocketLevel;

    super.init();
  }

  var pause = false;
  override function update() {
    if(!pause)
      current_level.update();

    if(Rl.isKeyPressed(Rl.Keys.F5))
      pause = !pause;
  }

  override function draw() {
    super.draw();
  }

  override function close() {
    super.close();
  }

  static function main() {
    new Game();
  }
}