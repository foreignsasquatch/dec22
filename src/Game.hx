import level.ForestLevel;
import level.RocketLevel;
import rx.Application;

class Game extends Application {
  public var rocketLevel:RocketLevel;
  public var forestLevel:ForestLevel;

  override function init() {
    LargeAssets.load();

    rocketLevel = new RocketLevel();
    Application.current_level = rocketLevel;
    // Application.current_level = new ForestLevel();

    super.init();
  }

  var pause = false;
  override function update() {
    if(!pause)
      Application.current_level.update();

    if(Rl.isKeyPressed(Rl.Keys.F5))
      pause = !pause;

    if(Application.current_level.done) {
      Application.current_level = new ForestLevel();
      Application.current_level.init();
    }
  }

  override function draw() {
    Application.current_level.draw();
  }

  override function close() {
    Application.current_level.close();
  }

  static function main() {
    new Game();
  }
}