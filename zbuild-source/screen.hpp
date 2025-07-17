#pragma once
#include <sys/ioctl.h>
#include <unistd.h>

static uint16_t get_screen_width() {
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_col;
}

static uint16_t get_screen_height() {
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return w.ws_row;
}

// Now you can define globals like this:
const uint16_t SCREEN_WIDTH = get_screen_width();
const uint16_t SCREEN_HEIGHT = get_screen_height();
