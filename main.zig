const std = @import("std");

pub fn addition(number1: i32, number2: i32) i32 {
    return number1 + number2;
}

pub fn substraction(number1: i32, number2: i32) i32 {
    return number1 - number2;
}

pub fn multiplication(number1: i32, number2: i32) i32 {
    return number1 * number2;
}

pub fn division(number1: i32, number2: i32) i32 {
    if (number2 == 0) {
        std.debug.panic("Division by zero", .{});
    }
    return @divTrunc(number1, number2);
}

pub fn main() !void {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var result: i32 = 0;
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 4) {
        std.debug.print("Too many arguments or too less arguments, you have to write 3 arguments: number 1 / number 2 / operation(+,-,*,/)\n", .{});
        std.process.exit(1);
    } else {
        const operator = args[3];
        const operator_plus: []const u8 = "+";
        const operator_minus: []const u8 = "-";
        const operator_multiply: []const u8 = "*";
        const operator_divide: []const u8 = "/";
        const num1 = std.fmt.parseInt(i32, args[1], 10) catch {
            std.debug.print("Invalid number: {s}\n", .{args[1]});
            return;
        };
        const num2 = std.fmt.parseInt(i32, args[2], 10) catch {
            std.debug.print("Invalid number: {s}\n", .{args[2]});
            return;
        };

        if ((std.mem.eql(u8, operator, operator_plus) or std.mem.eql(u8, operator, operator_minus) or std.mem.eql(u8, operator, operator_multiply) or std.mem.eql(u8, operator, operator_divide))) {
            const op = args[3][0];
            switch (op) {
                '+' => {
                    result = addition(num1, num2);
                    std.debug.print("  {d}\n", .{result});
                    std.process.exit(0);
                },
                '-' => {
                    result = substraction(num1, num2);
                    std.debug.print("  {d}\n", .{result});
                    std.process.exit(0);
                },
                '*' => {
                    result = multiplication(num1, num2);
                    std.debug.print("  {d}\n", .{result});
                    std.process.exit(0);
                },
                '/' => {
                    result = division(num1, num2);
                    std.debug.print("  {d}\n", .{result});
                    std.process.exit(0);
                },
                else => {
                    std.debug.print("Unknown operation: {c}\n", .{op});
                },
            }
        }
    }
}
