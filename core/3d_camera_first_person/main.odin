package main

import rl "vendor:raylib"

MAX_COLUMNS :: 20

main :: proc() {
    screenWidth :: 800
    screenHeight :: 450

    rl.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person")

    camera: rl.Camera
    camera.position = rl.Vector3({0.0, 2.0, 4.0})
    camera.target = rl.Vector3({0.0, 2.0, 0.0})
    camera.up = rl.Vector3({0.0, 2.0, 0.0})
    camera.fovy = 60.0
    camera.projection = rl.CameraProjection.PERSPECTIVE

    cameraMode: i32 = i32(rl.CameraMode.FIRST_PERSON)

    heights: [MAX_COLUMNS]f32
    positions: [MAX_COLUMNS]rl.Vector3
    colors: [MAX_COLUMNS]rl.Color

    for i in 0..<MAX_COLUMNS {
        heights[i] = f32(rl.GetRandomValue(1, 12))
        positions[i] = rl.Vector3({f32(rl.GetRandomValue(-15, 15)), heights[i] / 2.0, f32(rl.GetRandomValue(-15, 15))})
        colors[i] = rl.Color({u8(rl.GetRandomValue(20, 255)), u8(rl.GetRandomValue(10, 55)), 30, 255})
    }

    rl.DisableCursor()

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(rl.KeyboardKey.ONE) {
            cameraMode = i32(rl.CameraMode.FREE)
            camera.up = rl.Vector3{0.0, 1.0, 0.0}
        }

        if rl.IsKeyPressed(rl.KeyboardKey.TWO) {
            cameraMode = i32(rl.CameraMode.FIRST_PERSON)
            camera.up = rl.Vector3({0.0, 1.0, 0.0})
        }

        if rl.IsKeyPressed(rl.KeyboardKey.THREE) {
            cameraMode = i32(rl.CameraMode.THIRD_PERSON)
            camera.up = rl.Vector3({0.0, 1.0, 0.0})
        }

        if rl.IsKeyPressed(rl.KeyboardKey.FOUR) {
            cameraMode = i32(rl.CameraMode.ORBITAL) 
            camera.up = rl.Vector3({0.0, 0.1, 0.0})
        }

        if rl.IsKeyPressed(rl.KeyboardKey.P) {
            if camera.projection == rl.CameraProjection.PERSPECTIVE {
                cameraMode = i32(rl.CameraMode.THIRD_PERSON)
                camera.position = rl.Vector3({0.0, 2.0, -100.0})
                camera.target = rl.Vector3({0.0, 2.0, 0.0})
                camera.up = rl.Vector3({0.0, 1.0, 0.0})
                camera.projection = rl.CameraProjection.ORTHOGRAPHIC
                camera.fovy = 20.0
            }
            else if camera.projection == rl.CameraProjection.ORTHOGRAPHIC {
                cameraMode = i32(rl.CameraMode.THIRD_PERSON)
                camera.position = rl.Vector3({0.0, 2.0, 10.0})
                camera.target = rl.Vector3({0.0, 2.0, 0.0})
                camera.up = rl.Vector3({0.0, 1.0, 0.0})
                camera.projection = rl.CameraProjection.PERSPECTIVE
                camera.fovy = 60.0
            }
        }

        rl.UpdateCamera(&camera, rl.CameraMode(cameraMode))

        rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)

            rl.BeginMode3D(camera)
                rl.DrawPlane(rl.Vector3({0.0, 0.0, 0.0}), rl.Vector2({32.0, 32.0}), rl.LIGHTGRAY)

                rl.DrawCube(rl.Vector3({-16.0, 2.5, 0.0}), 1.0, 5.0, 32.0, rl.BLUE)
                rl.DrawCube(rl.Vector3({16.0, 2.5, 0.0}), 1.0, 5.0, 32.0, rl.LIME)
                rl.DrawCube(rl.Vector3({0.0, 2.5, 16.0}), 32.0, 50, 1.0, rl.GOLD)

                for i in 0..<MAX_COLUMNS {
                    rl.DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i])
                    rl.DrawCubeWires(positions[i], 2.0, heights[i], 2.0, rl.MAROON)
                }

                if cameraMode == i32(rl.CameraMode.THIRD_PERSON) {
                    rl.DrawCube(camera.target, 0.5, 0.5, 0.5, rl.PURPLE)
                    rl.DrawCubeWires(camera.target, 0.5, 0.5, 0.5, rl.DARKPURPLE)
                }
            rl.EndMode3D()

            rl.DrawRectangle(5, 5, 330, 100, rl.ColorAlpha(rl.SKYBLUE, 0.5));
            rl.DrawRectangleLines(10, 10, 330, 100, rl.BLUE);

            rl.DrawText("Camera controls:", 15, 15, 10, rl.BLACK);
            rl.DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, rl.BLACK);
            rl.DrawText("- Look around: arrow keys or mouse", 15, 45, 10, rl.BLACK);
            rl.DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, rl.BLACK);
            rl.DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, rl.BLACK);
            rl.DrawText("- Camera projection key: P", 15, 90, 10, rl.BLACK);

            rl.DrawRectangle(600, 5, 195, 100, rl.Fade(rl.SKYBLUE, 0.5));
            rl.DrawRectangleLines(600, 5, 195, 100, rl.BLUE);

            rl.DrawText("Camera status:", 610, 15, 10, rl.BLACK);
            rl.DrawText("- Mode: {cameraMode}", 610, 30, 10, rl.BLACK);
            rl.DrawText("- Projection: {camera.Projection}", 610, 45, 10, rl.BLACK);
            rl.DrawText("- Position: {camera.Position}", 610, 60, 10, rl.BLACK);
            rl.DrawText("- Target: {camera.Target}", 610, 75, 10, rl.BLACK);
            rl.DrawText("- Up: {camera.Up}", 610, 90, 10, rl.BLACK);
        rl.EndDrawing()
    }

    rl.CloseWindow()
}