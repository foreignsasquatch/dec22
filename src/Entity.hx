import ldtk.Layer_Tiles;

class Entity {
    public var sprite:Rl.Texture;

    public var cx:Int;
    public var cy:Int;
    public var xr:Float;
    public var yr:Float;

    public var xx:Float;
    public var yy:Float;

    public var dx:Float;
    public var dy:Float;

    public var texSquashX = 1.0;
    public var texSquashY = 1.0;

    public var map:ldtk.Layer_Tiles;
    public var onFloor = false;

    public function new(m:ldtk.Layer_Tiles) {
        map = m;
    }

    public function update() {
        xr += dx;
        dx *= 0.8;

        if(map.isCoordValid(cx + 1, cy) && map.hasAnyTileAt(cx + 1, cy) && xr >= 0) {
            xr = 0;
            dx = 0;
        }

        if(map.isCoordValid(cx - 1, cy) && map.hasAnyTileAt(cx - 1, cy) && xr <= 0) {
            xr = 0;
            dx = 0;
        }

        while(xr > 1) {
            xr--; cx++;
        }
        while(xr < 0) {
            xr++; cx--;
        }

        yr += dy;
        dy *= 0.98;

        // Ceiling
        if(map.isCoordValid(cx, cy - 1) && map.hasAnyTileAt(cx, cy - 1) && yr <= 0) {
            yr = 0;
            dy = 0;
        }

        // Floor
        if(map.isCoordValid(cx, cy + 1) && map.hasAnyTileAt(cx, cy + 1) && yr >= 0) {
            yr = 0;
            dy = 0;

            onFloor = true;
        } else {
            onFloor = false;
        }

        while(yr > 1) {
            yr--; cy++;
        }
        while(yr < 0) {
            yr++; cy--;
        }

        xx = (cx + xr) * 16;
        yy = (cy + yr) * 16;
    }

    public function draw() {
        var width = 16;
        var width_visual = width * texSquashX;
        var width_difference = width - width_visual;
        var x_offset = xx + (width_difference / 2);

        var width_visual_y = width * texSquashY;
        var width_difference_y = width - width_visual_y;
        var y_offset = yy + (width_difference_y / 2);

        Rl.drawTexturePro(sprite, Rl.Rectangle.create(0, 0, 16, 16), Rl.Rectangle.create(x_offset, y_offset, 16 * texSquashX, 16 * texSquashY), Rl.Vector2.create(0, 0), 0, Rl.Colors.WHITE);

        texSquashX += (1 - texSquashX) * Math.min(1, 0.2 * 0.6);
        texSquashY += (1 - texSquashY) * Math.min(1, 0.2 * 0.6);
    }

    public function setCoords(x, y) {
        xx = x;
        yy = y;
        cx = Std.int(xx / 16);
        cy = Std.int(yy / 16);
        xr = (xx - cx * 16) / 16;
        yr = (yy - cy * 16) / 16;
    }

    public function setSquashX(scaleX:Float) {
        texSquashX = scaleX;
        texSquashY = 2 - scaleX;
    }

    public function setSquashY(scaleY:Float) {
        texSquashX = 2 - scaleY;
        texSquashY = scaleY;
    }
}