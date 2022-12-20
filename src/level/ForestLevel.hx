package level;

import rx.tilemap.LdtkHelper;
import rx.aseprite.Loader;
import en.Player;
import rx.Level;

class ForestLevel extends Level {
  public var player_a:Player;
  public var player_b:Player;

  public var ldtk_map:LdtkMap;
  public var tilemap_texture:Rl.Texture;

  public var split_screen_rectangle:Rl.Rectangle;
  public var screen_a:Rl.RenderTexture;
  public var screen_b:Rl.RenderTexture; 

  public var fade:Rl.Color = Rl.Color.create(0, 0, 0, 255);
  public var fade_a:Rl.Color = Rl.Color.create(0, 0, 0, 255);
  public var fade_b:Rl.Color = Rl.Color.create(0, 0, 0, 255);

  public var separator:Rl.Texture;

  public var level_name_timer:Float = 0.5;
  public var level_name_fade:Rl.Color = Rl.Colors.WHITE;

  override function init() {
    ldtk_map = new LdtkMap(sys.io.File.getContent("res/map.ldtk"));
    tilemap_texture = Loader.loadTexture("res/tileset.aseprite");

    separator = Loader.loadTexture("res/separator.aseprite");

    player_a = new Player(ldtk_map.all_levels.level_1.l_en.all_player[0].cx * 16, ldtk_map.all_levels.level_1.l_en.all_player[0].cy * 16, "res/player_a_spr.aseprite", {
      LEFT: Rl.Keys.LEFT,
      RIGHT: Rl.Keys.RIGHT,
      JUMP: Rl.Keys.UP,
      INTERACT: Rl.Keys.Z
    }, ldtk_map.all_levels.level_1.l_fg);

    player_b = new Player(ldtk_map.all_levels.level_1.l_en.all_player[1].cx * 16, ldtk_map.all_levels.level_1.l_en.all_player[1].cy * 16, "res/player_b.aseprite", {
      LEFT: Rl.Keys.A,
      RIGHT: Rl.Keys.D,
      JUMP: Rl.Keys.W,
      INTERACT: Rl.Keys.SPACE
    }, ldtk_map.all_levels.level_1.l_fg);

    split_screen_rectangle = Rl.Rectangle.create(0, 0, Rl.getScreenWidth() / 2, -Rl.getScreenHeight());
    screen_a = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());
    screen_b = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());
  }

  var play_death = false;
  var death_anim_over = false;

  var play_death_a = false;
  var play_death_b = false;
  override function update() {
    if(play_death) {
      if(fade.a != 0) {
        fade.a = fade.a - 5;
      } else {
      }

      if(fade.a == 0) {
        death_anim_over = true;
      }

      if(death_anim_over) {
        play_death = false;
        fade.a = 255;
        death_anim_over = false;
      }
    }

    if(play_death_a) {
      if(fade_a.a != 0) {
        fade_a.a = fade_a.a - 5;
      } else {

      }

      if(fade_a.a == 0) {
        death_anim_over = true;
      }

      if(death_anim_over) {
        play_death_a = false;
        fade_a.a = 255;
        death_anim_over = false;
      }
    }

    if(play_death_b) {
      if(fade_b.a != 0) {
        fade_b.a = fade_b.a - 5;
      } else {

      }

      if(fade_b.a == 0) {
        death_anim_over = true;
      }

      if(death_anim_over) {
        play_death_b = false;
        fade_b.a = 255;
        death_anim_over = false;
      }
    }

    // die when hit death block
    for(d in ldtk_map.all_levels.level_1.l_en.all_death) {
      if(d.cx == player_a.cell_x && d.cy == player_a.cell_y) {
        play_death_a = true;

        player_a.cell_x = ldtk_map.all_levels.level_1.l_en.all_player[0].cx;
        player_a.cell_y = ldtk_map.all_levels.level_1.l_en.all_player[0].cy;
      }

      if(d.cx == player_b.cell_x && d.cy == player_b.cell_y) {
        play_death_b = true;

        player_b.cell_x = ldtk_map.all_levels.level_1.l_en.all_player[1].cx;
        player_b.cell_y = ldtk_map.all_levels.level_1.l_en.all_player[1].cy;
      }
    }

    player_a.update();
    player_b.update();
    // updateCamB();
    updateCamera();
  }

  override function draw() {
    // Player A view
    Rl.beginTextureMode(screen_a);
    Rl.clearBackground(Rl.Colors.BLACK);
    Rl.beginMode2D(player_a.camera);
    {
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_1.l_fg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_1.l_bg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      player_a.draw();
      player_b.draw();
    }
    Rl.endMode2D();

    if(play_death_a) Rl.drawRectangle(0, 0, Rl.getScreenWidth(), Rl.getScreenHeight(), fade_a);
    Rl.endTextureMode();

    // Player B view
    Rl.beginTextureMode(screen_b);
    Rl.clearBackground(Rl.Colors.BLACK);

    Rl.beginMode2D(player_b.camera);
    {
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_1.l_fg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_1.l_bg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      player_a.draw();
      player_b.draw();
    }
    Rl.endMode2D();

    if(play_death_b) Rl.drawRectangle(0, 0, Rl.getScreenWidth(), Rl.getScreenHeight(), fade_b);
    Rl.endTextureMode();

    Rl.beginDrawing();
    {
      Rl.clearBackground(Rl.Colors.BLACK);
      Rl.drawTextureRec(screen_a.texture, split_screen_rectangle, Rl.Vector2.zero(), Rl.Colors.WHITE);
      Rl.drawTextureRec(screen_b.texture, split_screen_rectangle, Rl.Vector2.create(Rl.getScreenWidth() / 2, 0), Rl.Colors.WHITE);
      Rl.drawTexture(separator, Std.int(Rl.getScreenWidth() / 2) - 10, 0, Rl.Colors.WHITE);

      if(play_death) Rl.drawRectangle(0, 0, Rl.getScreenWidth(), Rl.getScreenHeight(), fade);
      if(!(level_name_timer <= 0)) Rl.drawText("Level 2: Forest", Std.int((Rl.getScreenWidth() / 2)) - 150, 0, 50, level_name_fade);
      level_name_timer -= 0.01;
      level_name_fade.a = level_name_fade.a - 4;
    }
    Rl.endDrawing();
  }

  override function close() {
    Rl.unloadRenderTexture(screen_a);
    Rl.unloadRenderTexture(screen_b);
  }

  public var stun_timer = 0.0;
  public function updateCamera() {
    var o_y = 125;

    player_a.camera.offset.x = (Rl.getScreenWidth() / 2) / 2;
    player_a.camera.offset.y = (Rl.getScreenHeight() / 2) + o_y;

    player_b.camera.offset.x = (Rl.getScreenWidth() / 2) / 2;
    player_b.camera.offset.y = (Rl.getScreenHeight() / 2) + o_y;

    player_a.camera.target = Rl.Vector2.create(player_a.x, player_a.y);
    player_b.camera.target = Rl.Vector2.create(player_b.x, player_b.y);
    trace(player_a.camera.target.x);

    if(player_a.camera.target.x <= 88 ) player_a.camera.target.x = 88;
    if(player_a.x < 5) {
      player_a.can_move = false;
      player_a.velocity_x = 0;
      player_a.velocity_x = 0.5;
      player_a.velocity_y = -0.2;
      player_a.setCoords(8, player_a.y);
      player_a.can_move = false;
      stun_timer = 0.5;
    } else {
    }

    if(player_a.camera.target.x >= 2150 ) player_a.camera.target.x = 2150;
    if(player_a.x < 2180) {
      player_a.can_move = false;
      player_a.velocity_x = 0;
      player_a.velocity_x = 0.5;
      player_a.velocity_y = -0.2;
      player_a.setCoords(8, player_a.y);
      player_a.can_move = false;
      stun_timer = 0.5;
    } else {
    }

    if(stun_timer == 0)
      player_a.can_move = true;

    stun_timer -= 0.016;
    if(stun_timer < 0) stun_timer = 0;
  }

  public function updateCamB() {
    updateCamera();

    var x_scroll_min = (Rl.getScreenWidth() / 2) / 2;
    var y_scroll_min = 720;

    var x_scroll_max = 2224 - (Rl.getScreenWidth() / 2) / 2;
    var y_scroll_max = 528 - (Rl.getScreenHeight() / 2);

    if(player_a.x < x_scroll_min) player_a.camera.offset.x = player_a.x;
    if(player_a.y < y_scroll_min) player_a.camera.offset.y = player_a.y;
    if(player_a.x > x_scroll_max) {
      var offset = player_a.x - x_scroll_max;
      player_a.camera.offset.x = player_a.camera.offset.x + offset;
    }
    if(player_a.y > y_scroll_max) {
      var offset = player_a.y - y_scroll_max;
      player_a.camera.offset.y = player_a.camera.offset.y + offset;
    }
  }
}