package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

// Constants
SCREEN_WIDTH  :: 800
SCREEN_HEIGHT :: 600
GAME_TITLE    :: "Space Invaders 3D"

// Game states
GameState :: enum {
    MENU,
    PLAYING,
    GAME_OVER,
    WIN,
}

// Player structure
Player :: struct {
    position: rl.Vector3,
    size: rl.Vector3,
    speed: f32,
    color: rl.Color,
}

// Bullet structure
Bullet :: struct {
    position: rl.Vector3,
    velocity: rl.Vector3,
    active: bool,
    color: rl.Color,
}

// Enemy structure
Enemy :: struct {
    position: rl.Vector3,
    size: rl.Vector3,
    active: bool,
    color: rl.Color,
}

// Game state
Game :: struct {
    state: GameState,
    player: Player,
    bullets: [dynamic]Bullet,
    enemies: [dynamic]Enemy,
    enemy_bullets: [dynamic]Bullet,
    score: int,
    camera: rl.Camera3D,
}

game: Game

// Initialize the game
init_game :: proc() {
    game.state = .PLAYING
    game.score = 0

    // Initialize player
    game.player = Player{
        position = {0, 0, 0},
        size = {1.0, 0.5, 1.0},
        speed = 5.0,
        color = rl.GREEN,
    }

    // Initialize dynamic arrays
    game.bullets = make([dynamic]Bullet, 0, 100)
    game.enemy_bullets = make([dynamic]Bullet, 0, 100)
    game.enemies = make([dynamic]Enemy, 0, 100)

    // Create enemy grid
    ENEMY_ROWS :: 4
    ENEMY_COLS :: 8
    ENEMY_SPACING :: 2.5

    for row in 0..<ENEMY_ROWS {
        for col in 0..<ENEMY_COLS {
            enemy := Enemy{
                position = {
                    f32(col - ENEMY_COLS/2) * ENEMY_SPACING,
                    2.0,
                    f32(-15.0 - row * ENEMY_SPACING),
                },
                size = {0.8, 0.8, 0.8},
                active = true,
                color = rl.RED,
            }
            append(&game.enemies, enemy)
        }
    }

    // Setup camera
    game.camera = rl.Camera3D{
        position = {0, 8, 15},
        target = {0, 0, 0},
        up = {0, 1, 0},
        fovy = 45.0,
        projection = .PERSPECTIVE,
    }
}

// Update player
update_player :: proc(delta_time: f32) {
    // Movement
    if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
        game.player.position.x -= game.player.speed * delta_time
    }
    if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
        game.player.position.x += game.player.speed * delta_time
    }

    // Clamp player position
    MAX_X :: 10.0
    game.player.position.x = clamp(game.player.position.x, -MAX_X, MAX_X)

    // Shooting
    if rl.IsKeyPressed(.SPACE) {
        bullet := Bullet{
            position = game.player.position + {0, 0.5, 0},
            velocity = {0, 0, -15},
            active = true,
            color = rl.YELLOW,
        }
        append(&game.bullets, bullet)
    }
}

// Update bullets
update_bullets :: proc(delta_time: f32) {
    // Update player bullets
    for &bullet in game.bullets {
        if !bullet.active do continue

        bullet.position += bullet.velocity * delta_time

        // Deactivate if out of bounds
        if bullet.position.z < -30 || bullet.position.z > 30 {
            bullet.active = false
        }
    }

    // Update enemy bullets
    for &bullet in game.enemy_bullets {
        if !bullet.active do continue

        bullet.position += bullet.velocity * delta_time

        // Deactivate if out of bounds
        if bullet.position.z < -30 || bullet.position.z > 30 {
            bullet.active = false
        }
    }
}

// Update enemies
update_enemies :: proc(delta_time: f32) {
    // Simple side-to-side movement
    time := f32(rl.GetTime())
    offset := math.sin(time * 0.5) * 5.0

    for &enemy in game.enemies {
        if !enemy.active do continue

        // Update x position based on sine wave
        base_x := enemy.position.x
        enemy.position.x = base_x + offset * 0.1

        // Random shooting
        if rl.GetRandomValue(0, 1000) < 2 {
            bullet := Bullet{
                position = enemy.position - {0, 0.5, 0},
                velocity = {0, 0, 8},
                active = true,
                color = rl.MAGENTA,
            }
            append(&game.enemy_bullets, bullet)
        }
    }
}

// Check collisions
check_collisions :: proc() {
    // Player bullets vs enemies
    for &bullet in game.bullets {
        if !bullet.active do continue

        for &enemy in game.enemies {
            if !enemy.active do continue

            // Simple AABB collision
            if abs(bullet.position.x - enemy.position.x) < enemy.size.x &&
               abs(bullet.position.y - enemy.position.y) < enemy.size.y &&
               abs(bullet.position.z - enemy.position.z) < enemy.size.z {
                bullet.active = false
                enemy.active = false
                game.score += 10
            }
        }
    }

    // Enemy bullets vs player
    for &bullet in game.enemy_bullets {
        if !bullet.active do continue

        if abs(bullet.position.x - game.player.position.x) < game.player.size.x &&
           abs(bullet.position.y - game.player.position.y) < game.player.size.y &&
           abs(bullet.position.z - game.player.position.z) < game.player.size.z {
            bullet.active = false
            game.state = .GAME_OVER
        }
    }

    // Check win condition
    all_dead := true
    for enemy in game.enemies {
        if enemy.active {
            all_dead = false
            break
        }
    }
    if all_dead && game.state == .PLAYING {
        game.state = .WIN
    }
}

// Update game
update_game :: proc(delta_time: f32) {
    switch game.state {
    case .PLAYING:
        update_player(delta_time)
        update_bullets(delta_time)
        update_enemies(delta_time)
        check_collisions()

    case .MENU, .GAME_OVER, .WIN:
        if rl.IsKeyPressed(.ENTER) {
            // Reset game
            clear(&game.bullets)
            clear(&game.enemy_bullets)
            clear(&game.enemies)
            init_game()
        }
    }
}

// Draw the game
draw_game :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.BLACK)

    rl.BeginMode3D(game.camera)
    defer rl.EndMode3D()

    // Draw grid for reference
    rl.DrawGrid(40, 1.0)

    // Draw player
    rl.DrawCube(game.player.position, game.player.size.x, game.player.size.y, game.player.size.z, game.player.color)
    rl.DrawCubeWires(game.player.position, game.player.size.x, game.player.size.y, game.player.size.z, rl.DARKGREEN)

    // Draw bullets
    for bullet in game.bullets {
        if !bullet.active do continue
        rl.DrawSphere(bullet.position, 0.2, bullet.color)
    }

    // Draw enemy bullets
    for bullet in game.enemy_bullets {
        if !bullet.active do continue
        rl.DrawSphere(bullet.position, 0.2, bullet.color)
    }

    // Draw enemies
    for enemy in game.enemies {
        if !enemy.active do continue
        rl.DrawCube(enemy.position, enemy.size.x, enemy.size.y, enemy.size.z, enemy.color)
        rl.DrawCubeWires(enemy.position, enemy.size.x, enemy.size.y, enemy.size.z, rl.MAROON)
    }

    // Draw UI
    rl.DrawText(fmt.ctprintf("SCORE: %d", game.score), 10, 10, 20, rl.WHITE)

    switch game.state {
    case .MENU:
        rl.DrawText("SPACE INVADERS 3D", SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 50, 30, rl.WHITE)
        rl.DrawText("Press ENTER to start", SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 + 20, 20, rl.GRAY)

    case .GAME_OVER:
        rl.DrawText("GAME OVER", SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 - 50, 40, rl.RED)
        rl.DrawText(fmt.ctprintf("Final Score: %d", game.score), SCREEN_WIDTH/2 - 80, SCREEN_HEIGHT/2 + 20, 20, rl.WHITE)
        rl.DrawText("Press ENTER to restart", SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 + 60, 20, rl.GRAY)

    case .WIN:
        rl.DrawText("YOU WIN!", SCREEN_WIDTH/2 - 80, SCREEN_HEIGHT/2 - 50, 40, rl.GREEN)
        rl.DrawText(fmt.ctprintf("Final Score: %d", game.score), SCREEN_WIDTH/2 - 80, SCREEN_HEIGHT/2 + 20, 20, rl.WHITE)
        rl.DrawText("Press ENTER to restart", SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 + 60, 20, rl.GRAY)

    case .PLAYING:
        // Game is playing, no overlay
    }

    rl.DrawFPS(10, 40)
}

main :: proc() {
    // Initialize window
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, GAME_TITLE)
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    // Initialize game
    init_game()

    // Main game loop
    for !rl.WindowShouldClose() {
        delta_time := rl.GetFrameTime()

        update_game(delta_time)
        draw_game()
    }

    // Cleanup
    delete(game.bullets)
    delete(game.enemy_bullets)
    delete(game.enemies)
}
