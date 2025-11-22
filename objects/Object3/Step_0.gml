#region cutscene
// Evento Step
if (keyboard_check_pressed(vk_tab)) {
    if (room == Room6) { // se estiver na room6
        room_goto(Room7); // volta para room2
    }
}

// Evento Step
if (keyboard_check_pressed(vk_tab)) {
    if (room == Room7) { // se estiver na room6
        room_goto(Room1); // volta para room2
    }
}
#endregion
