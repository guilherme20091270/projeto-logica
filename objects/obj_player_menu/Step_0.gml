// Movimento no menu
if (keyboard_check(vk_right)) x += menu_speed;
if (keyboard_check(vk_left)) x -= menu_speed;
if (keyboard_check(vk_up)) y -= menu_speed;
if (keyboard_check(vk_down)) y += menu_speed;

// Limitar dentro da room
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

// Verifica se está em cima de algum marcador de fase
can_enter = false;
current_phase = noone;

with (obj_phase_marker) {
    if (place_meeting(other.x, other.y, id)) {
        other.can_enter = true;
        other.current_phase = id; // guarda qual fase
    }
}

// Entrar na fase
if (keyboard_check_pressed(vk_enter) && can_enter) {
    // Vai para a room da fase marcada
    room_goto(room); // cada obj_phase_marker tem a room que representa a fase
}
