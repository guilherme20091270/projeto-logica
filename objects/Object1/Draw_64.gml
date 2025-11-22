if (fade > 0) {
    draw_set_alpha(fade);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1); // resetar transparência
}
