#include <allegro5/allegro.h>
#include <allegro5/allegro_color.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <iostream>
#include <cstdlib>

static bool play = false;
static ALLEGRO_DISPLAY *display = nullptr;
static ALLEGRO_EVENT_QUEUE *event_queue = nullptr;

bool open();
void close();
void error(const char *msg = nullptr);
void handle_event(const ALLEGRO_EVENT &event);
void update(double dt);
void draw();

int main(int argc, char **argv) {
    if (!open()) {
        close();
        return EXIT_FAILURE;
    }

    ALLEGRO_EVENT event;
    double time_current = al_get_time(), time_prior = time_current;
    while (play) {
        while (al_get_next_event(event_queue, &event)) handle_event(event);
        update(time_current - time_prior);
        draw();
        time_prior = time_current;
        time_current = al_get_time();
    }

    close();
    return EXIT_SUCCESS;
}

bool open() {
    if (!al_init()) {
        error("Failed to initialize allegro.");
        return false;
    }
    if (!al_install_keyboard()) {
        error("Failed to install keyboard driver.");
        return false;
    }
    if (!al_install_mouse()) {
        error("Failed to install mouse driver.");
        return false;
    }
    if (!al_init_font_addon()) {
        error("Failed to initialize font addon.");
        return false;
    }
    if (!al_init_ttf_addon()) {
        error("Failed to initialize true-type font addon.");
        return false;
    }
    al_set_new_window_title("Hello Allegro");
    display = al_create_display(640, 480);
    if (!display) {
        error("Failed to create display.");
        return false;
    }
    event_queue = al_create_event_queue();
    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_register_event_source(event_queue, al_get_keyboard_event_source());
    al_register_event_source(event_queue, al_get_mouse_event_source());
    if (!event_queue) {
        error("Failed to create event queue.");
        return false;
    }
    play = true;
    return true;
}

void close() {
    al_destroy_event_queue(event_queue);
    al_destroy_display(display);
}

void error(const char *msg) {
    if (msg) std::cerr << msg << '\n';
}

void handle_event(const ALLEGRO_EVENT &event) {
    switch (event.type) {
    case ALLEGRO_EVENT_DISPLAY_CLOSE:
        play = false;
        break;
    case ALLEGRO_EVENT_KEY_DOWN:
        play = (event.keyboard.keycode != ALLEGRO_KEY_ESCAPE);
        break;
    }
}

void update(double dt) {
}

void draw() {
    al_clear_to_color(al_map_rgb(0,0,0));
    al_flip_display();
}
