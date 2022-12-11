package rx;

// Pretty simple code.
class Application {
  public var current_level:Level;

  public function init() {
    current_level.init();
  }

  public function update() {
    current_level.update();
  }

  public function draw() {
    current_level.draw();
  }

  public function close() {
    current_level.close();
  }

  public function new() {
    Rl.initWindow(1280, 720, "");
    Rl.setTargetFPS(60);

    init();

    var time_counter = 0.0;
    var time_step = 0.016;
    while (!Rl.windowShouldClose()) {
      // Update 60 times per second
      time_counter += Rl.getFrameTime();
      while (time_counter > time_step) {
        update();
        time_counter -= time_step;
      }

      draw();
    }

    close();

    Rl.closeWindow();
  }
}