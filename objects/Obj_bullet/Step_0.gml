// Movimento da bala
x += direction_x * speed;
y += direction_y * speed;

// Teleporte pelas bordas
if (x > room_width) x = 0;
if (x < 0) x = room_width;
if (y > room_height) y = 0;
if (y < 0) y = room_height;

// Colisão com bloco
if (can_destroy) {
    var alvo = instance_place(x, y, Object2);
    if (alvo != noone) {
        with (alvo) {
            image_index = 0;
            image_speed = 1;
            alarm[0] = sprite_get_number(sprite_index);
        }
        can_destroy = false;
        instance_destroy();
    }
}

// Tempo de vida
life_timer += 1;
if (life_timer > max_life) {
    instance_destroy();
}
