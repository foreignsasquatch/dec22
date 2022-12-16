package level;

import rx.tilemap.LdtkHelper;
import rx.aseprite.Loader;
import rx.Level;

import en.Rocket;
import en.Player;

class RocketLevel extends Level {
  // entities
  public var player_a:Player;
  public var player_b:Player;
  public var rocket:Rocket;
  public var is_rocket_active = false; 

  // tilemap stuff
  public var ldtk_map:LdtkMap;
  public var tilemap_texture:Rl.Texture;

  // split screen stuff
  public var split_screen_rectangle:Rl.Rectangle;
  public var screen_a:Rl.RenderTexture;
  public var screen_b:Rl.RenderTexture;

  public var endscreen_texture:Rl.Texture;

  public var fade:Rl.Color = Rl.Color.create(0, 0, 0, 255);
  public var fade_a:Rl.Color = Rl.Color.create(0, 0, 0, 255);
  public var fade_b:Rl.Color = Rl.Color.create(0, 0, 0, 255);

  public var level_name_timer:Float = 0.5;
  public var level_name_fade:Rl.Color = Rl.Colors.WHITE;

  public var separator:Rl.Texture;

  override function init() {
    // tilemap
    ldtk_map = new LdtkMap(sys.io.File.getContent("res/map.ldtk"));
    tilemap_texture = Loader.loadTexture("res/tileset.aseprite");

    separator = Loader.loadTexture("res/separator.aseprite");

    // en
    player_a = new Player(ldtk_map.all_levels.level_0.l_en.all_player[0].cx * 16, ldtk_map.all_levels.level_0.l_en.all_player[0].cy * 16, "res/player_a_spr.aseprite", {
      LEFT: Rl.Keys.LEFT,
      RIGHT: Rl.Keys.RIGHT,
      JUMP: Rl.Keys.UP,
      INTERACT: Rl.Keys.Z
    }, ldtk_map.all_levels.level_0.l_fg);

    player_b = new Player(ldtk_map.all_levels.level_0.l_en.all_player[1].cx * 16, ldtk_map.all_levels.level_0.l_en.all_player[1].cy * 16, "res/player_b.aseprite", {
      LEFT: Rl.Keys.A,
      RIGHT: Rl.Keys.D,
      JUMP: Rl.Keys.W,
      INTERACT: Rl.Keys.SPACE
    }, ldtk_map.all_levels.level_0.l_fg);

    rocket = new Rocket(ldtk_map.all_levels.level_0.l_en.all_rocket[1].cx * 16, ldtk_map.all_levels.level_0.l_en.all_rocket[1].cy * 16, ldtk_map.all_levels.level_0.l_fg);

    // split screen
    split_screen_rectangle = Rl.Rectangle.create(0, 0, Rl.getScreenWidth() / 2, -Rl.getScreenHeight());
    screen_a = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());
    screen_b = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());

    endscreen_texture = Loader.loadTexture("res/endscreen.aseprite");
  }

  var play_death = false;
  var death_anim_over = false;
  var has_teleported_to_rocket = false;

  var play_death_a = false;
  var play_death_b = false;
  override function update() {
    // rocket
    for(r in ldtk_map.all_levels.level_0.l_en.all_rocket) {
      if(r.cx == player_a.cell_x && r.cy == player_a.cell_y || r.cx == player_b.cell_x && r.cy == player_b.cell_y) {
        is_rocket_active = true;
      } 
    }

    if(ldtk_map.all_levels.level_0.l_en.all_rocket_end[0].cx == rocket.cell_x) {
      is_rocket_active = false;

      if(!has_teleported_to_rocket) {
        player_a.setCoords(rocket.x, rocket.y);
        player_b.setCoords(rocket.x, rocket.y);
        has_teleported_to_rocket = true;
      }
    }

    if(rocket.is_colliding) {
      rocket.setCoords(ldtk_map.all_levels.level_0.l_en.all_rocket[2].cx * 16, ldtk_map.all_levels.level_0.l_en.all_rocket[2].cy * 16);
      play_death = true;

      player_a.cell_x = ldtk_map.all_levels.level_0.l_en.all_player[0].cx;
      player_a.cell_y = ldtk_map.all_levels.level_0.l_en.all_player[0].cy;
      
      player_b.cell_x = ldtk_map.all_levels.level_0.l_en.all_player[1].cx;
      player_b.cell_y = ldtk_map.all_levels.level_0.l_en.all_player[1].cy;

      rocket.velocity_x = 0;
      rocket.velocity_y = 0;

      is_rocket_active = false;
      rocket.is_colliding = false;
    }

    if(is_rocket_active) rocket.update();

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

    // players
    player_a.update();
    player_b.update();
    updateCamera();

    for(d in ldtk_map.all_levels.level_0.l_en.all_death) {
      if(d.cx == player_a.cell_x && d.cy == player_a.cell_y) {
        play_death_a = true;

        player_a.cell_x = ldtk_map.all_levels.level_0.l_en.all_player[0].cx;
        player_a.cell_y = ldtk_map.all_levels.level_0.l_en.all_player[0].cy;
      }

      if(d.cx == player_b.cell_x && d.cy == player_b.cell_y) {
        play_death_b = true;

        player_b.cell_x = ldtk_map.all_levels.level_0.l_en.all_player[1].cx;
        player_b.cell_y = ldtk_map.all_levels.level_0.l_en.all_player[1].cy;
      }
    }
  }

  override function draw() {
    // Player A view
    Rl.beginTextureMode(screen_a);
    Rl.clearBackground(Rl.Colors.BLACK);
    Rl.drawTexture(LargeAssets.bg_b, 0, 0, Rl.Colors.WHITE);

    Rl.beginMode2D(player_a.camera);
    {
      Rl.drawTextureRec(tilemap_texture, Rl.Rectangle.create(16, 0, 16, 16), Rl.Vector2.create(ldtk_map.all_levels.level_0.l_en.all_rocket[0].pixelX, ldtk_map.all_levels.level_0.l_en.all_rocket[0].pixelY), Rl.Colors.WHITE);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_0.l_fg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_0.l_bg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);

      if(!is_rocket_active) {
        player_b.draw();
        player_a.draw();
      } else if(is_rocket_active) {
        rocket.draw();
      }
    }
    Rl.endMode2D();

    if(play_death_a) Rl.drawRectangle(0, 0, Rl.getScreenWidth(), Rl.getScreenHeight(), fade_a);
    Rl.endTextureMode();

    // Player B view
    Rl.beginTextureMode(screen_b);
    Rl.clearBackground(Rl.Colors.BLACK);
    Rl.drawTexture(LargeAssets.bg, 0, 0, Rl.Colors.WHITE);

    Rl.beginMode2D(player_b.camera);
    {
      Rl.drawTextureRec(tilemap_texture, Rl.Rectangle.create(16, 0, 16, 16), Rl.Vector2.create(ldtk_map.all_levels.level_0.l_en.all_rocket[0].pixelX, ldtk_map.all_levels.level_0.l_en.all_rocket[0].pixelY), Rl.Colors.WHITE);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_0.l_fg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);
      LdtkHelper.drawTilemap(ldtk_map.all_levels.level_0.l_bg, tilemap_texture, ldtk_map.all_tilesets.tileset, 16, 16);

      if(!is_rocket_active) {
        player_a.draw();
        player_b.draw();
      } else if(is_rocket_active) {
        rocket.draw();
      }
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
      if(!(level_name_timer <= 0)) Rl.drawText("Level 1: Dream", Std.int((Rl.getScreenWidth() / 2)) - 150, 0, 50, level_name_fade);
      level_name_timer -= 0.01;
      level_name_fade.a = level_name_fade.a - 4;
    }
    Rl.endDrawing();
  }

  override function close() {
    Rl.unloadRenderTexture(screen_a);
    Rl.unloadRenderTexture(screen_b);
  }

  public function updateCamera() {
    player_a.camera.offset.x = (Rl.getScreenWidth() / 2) / 2;
    player_a.camera.offset.y = (Rl.getScreenHeight() / 2);

    player_b.camera.offset.x = (Rl.getScreenWidth() / 2) / 2;
    player_b.camera.offset.y = (Rl.getScreenHeight() / 2);

    if(!is_rocket_active) {
      player_a.camera.target = Rl.Vector2.create(player_a.x, player_a.y);
      player_b.camera.target = Rl.Vector2.create(player_b.x, player_b.y);
    } else if(is_rocket_active) {
      player_a.camera.target = Rl.Vector2.create(rocket.x, rocket.y);
      player_b.camera.target = Rl.Vector2.create(rocket.x, rocket.y);
    }
  }
}