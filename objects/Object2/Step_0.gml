// Se estiver animando e terminou a animação → destruir
if (image_speed > 0 && image_index >= image_number - 1) {
    instance_destroy();
}
