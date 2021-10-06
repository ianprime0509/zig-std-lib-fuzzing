const std = @import("std");
const c = @cImport(@cInclude("math.h"));

pub export fn main() void {
    zigMain() catch unreachable;
}

pub fn zigMain() !void {
    // Read the data from stdin, only up to bytes needed for f64
    var buf align(@alignOf(f64)) = [_]u8{0} ** @sizeOf(f64);
    const stdin = std.io.getStdIn();
    _ = try stdin.read(buf[0..]);

    // f32
    const float32 = @ptrCast(*const f32, buf[0..@sizeOf(f32)]).*;
    std.debug.print("in : {b:0>32}\n", .{@bitCast(u32, float32)});
    const zig32 = std.math.sin(float32);
    const c32 = c.sinf(float32);
    if (std.math.isNan(c32)) {
        try std.testing.expect(std.math.isNan(zig32));
    } else {
        std.testing.expectEqual(c32, zig32) catch |err| {
            std.debug.print("zig: {b:0>32}\nc  : {b:0>32}\n", .{
                @bitCast(u32, zig32),
                @bitCast(u32, c32),
            });
            return err;
        };
    }

    // f64
    var float64 = @ptrCast(*const f64, buf[0..]).*;
    std.debug.print("in : {b:0>64}\n", .{@bitCast(u64, float64)});
    const zig64 = std.math.sin(float64);
    const c64 = c.sin(float64);
    if (std.math.isNan(c64)) {
        try std.testing.expect(std.math.isNan(zig64));
    } else {
        std.testing.expectEqual(c64, zig64) catch |err| {
            std.debug.print("zig: {b:0>64}\nc  : {b:0>64}\n", .{
                @bitCast(u64, zig64),
                @bitCast(u64, c64),
            });
            return err;
        };
    }
}
