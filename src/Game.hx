import level.RocketLevel;
import rx.Application;

class Game extends Application {
  public var rocketLevel:RocketLevel;

  override function init() {
    rocketLevel = new RocketLevel();
    current_level = rocketLevel;

    super.init();
  }

  override function update() {
    super.update();
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