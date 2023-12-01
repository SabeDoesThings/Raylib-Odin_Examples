package main

import rl "vendor:raylib"

MAX_BUILDINGS :: 100

main :: proc() {
    screenWidth :: 800
    screenHeight :: 450

    rl.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")

    player: rl.Rectangle = {400, 280, 40, 40}
    buildings: [MAX_BUILDINGS]rl.Rectangle
    buildColors: [MAX_BUILDINGS]rl.Color

    spacing: i32 = 0

    for i in 0..<MAX_BUILDINGS {
        buildings[i].width = f32(rl.GetRandomValue(50, 200))
        buildings[i].height = f32(rl.GetRandomValue(100, 800));
        buildings[i].y = screenHeight - 130.0 - buildings[i].height
        buildings[i].x = f32(-6000.0 + spacing)

        spacing += i32(buildings[i].width)

        buildColors[i] = rl.Color({u8(rl.GetRandomValue(200, 240)), u8(rl.GetRandomValue(200, 240)), u8(rl.GetRandomValue(200, 240)), 255})
    }

    camera: rl.Camera2D
    camera.target = rl.Vector2({player.x + 20.0, player.y + 20.0})
    camera.offset = rl.Vector2({screenWidth / 2.0, screenHeight / 2.0})
    camera.rotation = 0.0
    camera.zoom = 1.0

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(rl.KeyboardKey.RIGHT) do player.x += 2
        else if rl.IsKeyDown(rl.KeyboardKey.LEFT) do player.x -= 2

        camera.target = rl.Vector2({player.x + 20, player.y + 20})

        if rl.IsKeyDown(rl.KeyboardKey.A) do camera.rotation -= 1
        else if rl.IsKeyDown(rl.KeyboardKey.S) do camera.rotation += 1

        if camera.rotation > 40 do camera.rotation = 40
        else if camera.rotation < -40 do camera.rotation = -40

        camera.zoom += f32(rl.GetMouseWheelMove() * 0.05)
        
        if camera.zoom > 3.0 do camera.zoom = 3.0
        else if camera.zoom < 0.1 do camera.zoom = 0.1

        if rl.IsKeyPressed(rl.KeyboardKey.R) {
            camera.zoom = 1.0
            camera.rotation = 0.0
        }

        rl.BeginDrawing();
            rl.ClearBackground(rl.RAYWHITE)

            rl.BeginMode2D(camera)
                rl.DrawRectangle(-6000, 320, 13000, 8000, rl.DARKGRAY)

                for i in 0..<MAX_BUILDINGS do rl.DrawRectangleRec(buildings[i], buildColors[i])

                rl.DrawRectangleRec(player, rl.RED)

                rl.DrawLine(i32(camera.target.x), -screenHeight * 10, i32(camera.target.x), screenHeight * 10, rl.GREEN)
                rl.DrawLine(-screenWidth * 10, i32(camera.target.y), screenWidth * 10, i32(camera.target.y), rl.GREEN)
            rl.EndMode2D()

            rl.DrawText("SCREEN AREA", 640, 10, 20, rl.RED);

            rl.DrawRectangle(0, 0, screenWidth, 5, rl.RED);
            rl.DrawRectangle(0, 5, 5, screenHeight - 10, rl.RED);
            rl.DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, rl.RED);
            rl.DrawRectangle(0, screenHeight - 5, screenWidth, 5, rl.RED);

            rl.DrawRectangle( 10, 10, 250, 113, rl.Fade(rl.SKYBLUE, 0.5));
            rl.DrawRectangleLines( 10, 10, 250, 113, rl.BLUE);

            rl.DrawText("Free 2d camera controls:", 20, 20, 10, rl.BLACK);
            rl.DrawText("- Right/Left to move Offset", 40, 40, 10, rl.DARKGRAY);
            rl.DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, rl.DARKGRAY);
            rl.DrawText("- A / S to Rotate", 40, 80, 10, rl.DARKGRAY);
            rl.DrawText("- R to reset Zoom and Rotation", 40, 100, 10, rl.DARKGRAY);
        rl.EndDrawing();
    }

    rl.CloseWindow()
}