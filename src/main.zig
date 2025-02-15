const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    const screen_width: u32 = 160;
    const screen_height: u32 = 90;

    rl.setConfigFlags(.{ .window_resizable = true });
    rl.initWindow(screen_width, screen_height, "Float");
    defer rl.closeWindow();

    const player = Player.new();

    // Game Loop
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        player.draw();

        rl.drawText("Boy Town", 20, 20, 40, rl.Color.green);
    }
}

const World = struct {
    camera: ?*rl.Camera2D = null,
    player: ?*Player = null,

    const Self = @This();

    pub fn init() Self {
        return Self;
    }
};

const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,

    const Self = @This();

    pub fn new() Self {
        return Self{ .position = .{ .x = 0, .y = 0 }, .velocity = .{ .x = 0, .y = 0 } };
    }

    pub fn draw(self: Self) void {
        rl.drawCircleV(self.position, 32, rl.Color.ray_white);
    }
};

const Block = struct {
    position: rl.Vector2,
    extents: rl.Vector2,

    const Self = @This();

    pub fn draw(self: Self) void {
        rl.drawRectangleV(self.position, self.extents, rl.Color.red);
    }
};
