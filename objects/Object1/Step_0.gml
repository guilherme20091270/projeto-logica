// ======================
// Step Event do Player
// ======================

// ----------------------
// 1️⃣ Alternância de espinhos
// ----------------------
if (ds_map_exists(posicoes_por_room, room)) {
    if (keyboard_check_pressed(vk_space) && place_meeting(x, y + 1, Object2)) {
        destruir_espinhos();

        var listas_posicoes = posicoes_por_room[? room];

        if (espinho_ativo == 1) {
            espinho_ativo = 2;
            var espinho2_lista = listas_posicoes[| 1];
            criar_espinhos_ds(espinho2_lista, obj_espinho2);
        } else {
            espinho_ativo = 1;
            var espinho1_lista = listas_posicoes[| 0];
            criar_espinhos_ds(espinho1_lista, obj_espinho);
        }
    }
}

// ----------------------
// 2️⃣ Controles
// ----------------------
key_right = keyboard_check(ord("D"));
key_left = keyboard_check(ord("A"));
key_jump = keyboard_check(vk_space);

// ----------------------
// 3️⃣ Movimentação
// ----------------------
if (can_move) {
    var move = key_right - key_left;

    hspd = move * spd;
    vspd += grv;
    if (hspd != 0) image_xscale = sign(hspd);

    // colisão horizontal
    if (place_meeting(x + hspd, y, Object2)) {
        while (!place_meeting(x + sign(hspd), y, Object2)) {
            x += sign(hspd);
        }
        hspd = 0;
    }
    x += hspd;

    // colisão vertical
    if (place_meeting(x, y + vspd, Object2)) {
        while (!place_meeting(x, y + sign(vspd), Object2)) {
            y += sign(vspd);
        }
        vspd = 0;
    }
    y += vspd;

    // Jump
    if (place_meeting(x, y + 1, Object2) && key_jump) {
        vspd -= 10;

        // alterna o sprite do Object2
        with (Object2) {
            if (sprite_index == Sprite12) sprite_index = Sprite12_1;
            else sprite_index = Sprite12;
        }
    }

    // animação de movimento
    if (keyboard_check(vk_anykey)) sprite_index = Sprite6_1;
    else sprite_index = Sprite6;
}

// ----------------------
// 4️⃣ Teleporte / Wraparound
// ----------------------
if (x < -sprite_width / 2) x = room_width + sprite_width / 2;
if (x > room_width + sprite_width / 2) x = -sprite_width / 2;
if (y < -sprite_height / 2) y = room_height + sprite_height / 2;
if (y > room_height + sprite_height / 2) y = -sprite_height / 2;

// zera velocidade ao teletransportar
if (x == -sprite_width / 2 || x == room_width + sprite_width / 2 || y == -sprite_height / 2 || y == room_height + sprite_height / 2) {
    hspd = 0;
    vspd = 0;
}

// ----------------------
// 5️⃣ Próxima fase / chão e imortalidade
// ----------------------
on_ground = place_meeting(x, y + 1, Object2);

if (immortal_time > 0) {
    immortal_time -= 1;
    if ((immortal_time div 4) mod 2 == 0) image_alpha = 0.5;
    else image_alpha = 1;
} else image_alpha = 1;

// ----------------------
// 6️⃣ Fade / reinício com R
// ----------------------
if (keyboard_check_pressed(ord("R")) && !fading) {
    fading = true;
    can_move = false;
}

if (fading) {
    fade += 0.02;
    if (fade >= 1) room_restart();
}

// bloqueia movimento durante fade
if (!can_move) {
    hspd = 0;
    vspd = 0;
}

// ----------------------
// 7️⃣ Cutscene / Tab
// ----------------------
if (keyboard_check_pressed(vk_tab)) {
    if (room == Room6) room_goto(Room2);
}

// ----------------------
// 8️⃣ Progredir fase automaticamente
// ----------------------
if (flor == 2) room_goto_next();

// ----------------------
// 9️⃣ Destruir blocos com Q (até 2 por room)
// ----------------------

// Wrap para coordenadas
if (y > room_height) y = 0;
if (y < 0) y = room_height;
if (x > room_width) x = 0;
if (x < 0) x = room_width;

// Primeiro: aplicar wraparound
if (y > room_height) y = 0;
if (y < 0) y = room_height;
if (x > room_width) x = 0;
if (x < 0) x = room_width;

// Depois: destruir bloco
// Destruir bloco com Q (até 2 por room)
// Atirar com Q
// Atirar com Q (só se tiver a pistola e menos de 2 balas ativas)
#region Tiro com pistola
if (global.g_has_pistol && shots_used < 2) {
    if (keyboard_check_pressed(ord("Q"))) {

        var dir_x = 0;
        var dir_y = 0;

        // Define direção da bala
        if (keyboard_check(vk_right)) { 
            dir_x = 1; dir_y = 0; 
        }
        else if (keyboard_check(vk_left)) { 
            dir_x = -1; dir_y = 0; 
        }
        else if (keyboard_check(vk_up)) { 
            dir_x = 0; dir_y = -1; // agora pode atirar pra cima mesmo no chão
        }
        else if (keyboard_check(vk_down)) { 
            dir_x = 0; dir_y = 1;  // agora pode atirar pra baixo mesmo no chão
        }
        else { 
            dir_x = image_xscale; dir_y = 0; // padrão horizontal
        }

        // Cria a bala no centro do player
        var b = instance_create_layer(x, y, "Instances", Obj_bullet);
        b.direction_x = dir_x;
        b.direction_y = dir_y;
        b.owner = id;

        // Sprite da bala
        b.image_index = 0;
        b.image_speed = 1;

        shots_used += 1; // aumenta contador
    }
}
#endregion
