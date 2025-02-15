const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    const screen_width: u32 = 1600;
    const screen_height: u32 = 900;

    rl.setConfigFlags(.{ .window_resizable = true });
    rl.initWindow(screen_width, screen_height, "Float");
    defer rl.closeWindow();

    var player = Player.new();
    var block = Block.new();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var draw_list = std.ArrayList(DrawObject).init(allocator);

    try draw_list.append(player.drawer());
    try draw_list.append(block.drawer());

    // Game Loop
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        rl.drawText("Boy Town", 20, 20, 40, rl.Color.green);

        for (draw_list.items) |obj| {
            obj.draw();
        }
    }
}

const DrawObject = struct {
    ptr: *anyopaque,
    drawFn: *const fn (ptr: *anyopaque) void,

    const Self = @This();

    fn draw(self: Self) void {
        return self.drawFn(self.ptr);
    }
};

const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,

    const Self = @This();

    pub fn new() Self {
        return Self{ .position = .{ .x = 0, .y = 0 }, .velocity = .{ .x = 0, .y = 0 } };
    }

    pub fn draw(ptr: *anyopaque) void {
        // This step essentially casts our pointer: anyopaque -> Player
        const self: *Player = @ptrCast(@alignCast(ptr));
        rl.drawCircleV(self.position, 32, rl.Color.ray_white);
    }

    fn drawer(self: *Self) DrawObject {
        return .{
            .ptr = self,
            .drawFn = draw,
        };
    }
};

const Block = struct {
    position: rl.Vector2,
    extents: rl.Vector2,

    const Self = @This();

    pub fn new() Self {
        return Self{ .position = .{ .x = 800, .y = 450 }, .extents = .{ .x = 200, .y = 50 } };
    }

    pub fn draw(ptr: *anyopaque) void {
        const self: *Block = @ptrCast(@alignCast(ptr));
        rl.drawRectangleV(self.position, self.extents, rl.Color.red);
    }

    fn drawer(self: *Self) DrawObject {
        return .{
            .ptr = self,
            .drawFn = draw,
        };
    }
};
