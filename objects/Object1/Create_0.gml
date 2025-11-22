#region bagunçado pra krlh
espinho_ativo = 1;
lista_espinhos = ds_list_create();
posicoes_por_room = ds_map_create();
pulou_antes = false; // variável para evitar repetição no mesmo pulo
// Função para criar listas de posições (lista de listas)
function criar_lista_posicoes(array_posicoes) {
    var lista = ds_list_create();
    for (var i = 0; i < array_length(array_posicoes); i++) {
        var pos = array_posicoes[i];
        var pos_list = ds_list_create();
        ds_list_add(pos_list, pos[0]);
        ds_list_add(pos_list, pos[1]);
        ds_list_add(lista, pos_list);
    }
    return lista;
}

// Cria as posições usando ds_list

// Room1
var espinho1_room1 = criar_lista_posicoes([
        [320, 352],
        [448, 352],
        [576, 640]
]);

var espinho2_room1 = criar_lista_posicoes([
    [704, 352],
        [800, 352],
        [928, 352]
]);

var lista_room1 = ds_list_create();
ds_list_add(lista_room1, espinho1_room1);
ds_list_add(lista_room1, espinho2_room1);
ds_map_add(posicoes_por_room, Room1, lista_room1);

// Room2
var espinho1_room2 = criar_lista_posicoes([
    [544, 640],
    [576, 96],
	[704, 96   ],
	[
	 896, 96
	]]);

var espinho2_room2 = criar_lista_posicoes([
    [416, 224],
    [672, 224],
	[544,224 ]
]);

var lista_room2 = ds_list_create();
ds_list_add(lista_room2, espinho1_room2);
ds_list_add(lista_room2, espinho2_room2);
ds_map_add(posicoes_por_room, Room2, lista_room2);

// Room3
var espinho1_room3 = criar_lista_posicoes([
    [10, 10],
    [30, 30],
    [50, 50]
]);

var espinho2_room3 = criar_lista_posicoes([
    [70, 70],
    [90, 90]
]);

var lista_room3 = ds_list_create();
ds_list_add(lista_room3, espinho1_room3);
ds_list_add(lista_room3, espinho2_room3);



// Função para criar espinhos usando ds_list
function criar_espinhos_ds(lista_posicoes, tipo_espinho) {
    for (var i = 0; i < ds_list_size(lista_posicoes); i++) {
        var pos = lista_posicoes[| i];
        var x_pos = pos[| 0];
        var y_pos = pos[| 1];
        var inst = instance_create_layer(x_pos, y_pos, "Instances", tipo_espinho);
        ds_list_add(lista_espinhos, inst);
    }
}

// Função para destruir espinhos
function destruir_espinhos() {
    for (var i = 0; i < ds_list_size(lista_espinhos); i++) {
        var inst = lista_espinhos[| i];
        if (instance_exists(inst)) {
            instance_destroy(inst);
        }
    }
    ds_list_clear(lista_espinhos);
}

// Cria o grupo inicial na room atual, se tiver
if (ds_map_exists(posicoes_por_room, room)) {
    var listas_posicoes = posicoes_por_room[? room];
    var espinho1_lista = listas_posicoes[| 0];
    criar_espinhos_ds(espinho1_lista, obj_espinho);
}
#endregion



spd = 5;
hspd = 0;
vspd = 0;
grv = 0.4;
flor =0;
immortal_time = 0;
on_ground = false;
// Posição salva
if (variable_global_exists("saved_x") && variable_global_exists("saved_y")) {
    x = global.saved_x;
    y = global.saved_y;
}

// Tenta reposicionar o personagem em uma área livre até 64 pixels para cima, direita, esquerda e baixo
var desloc = 0;
var desloc_max = 64;
var pos_achada = false;

while (!pos_achada && desloc <= desloc_max) {
    // Checa cima
    if (!place_meeting(x, y - desloc, obj_espinho)) {
        y = y - desloc;
        pos_achada = true;
        break;
    }
    // Checa direita
    if (!place_meeting(x + desloc, y, obj_espinho)) {
        x = x + desloc;
        pos_achada = true;
        break;
    }
    // Checa esquerda
    if (!place_meeting(x - desloc, y, obj_espinho)) {
        x = x - desloc;
        pos_achada = true;
        break;
    }
    // Checa baixo
    if (!place_meeting(x, y + desloc, obj_espinho)) {
        y = y + desloc;
        pos_achada = true;
        break;
    }
    desloc += 1;
}

if (!pos_achada) {
    // Se não encontrou posição segura, posiciona em um ponto padrão (ex: 32,32)
    x = 32;
    y = 32;
}
#region efeito de morte
can_move = true;
fade = 0;
fading = false;

#endregion


// Pistola (global, não perde ao trocar de room)
if (!variable_global_exists("g_has_pistol")) {
    global.g_has_pistol = false;
}

// Tiros por room (instância, reseta a cada room)
shots_used = 0;

