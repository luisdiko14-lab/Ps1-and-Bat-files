#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h> // for usleep

#define WIDTH 80
#define HEIGHT 25

int main() {
    srand(time(NULL));

    // Array to track drops for each column
    int drops[WIDTH];
    for (int i = 0; i < WIDTH; i++) {
        drops[i] = rand() % HEIGHT;
    }

    while (1) {
        // Clear screen
        printf("\033[2J\033[H");

        // Draw the screen
        for (int row = 0; row < HEIGHT; row++) {
            for (int col = 0; col < WIDTH; col++) {
                if (drops[col] == row) {
                    // Random character
                    char c = 33 + rand() % 94; // printable ASCII
                    printf("\033[1;32m%c\033[0m", c); // green
                } else {
                    printf(" ");
                }
            }
            printf("\n");
        }

        // Move drops down
        for (int i = 0; i < WIDTH; i++) {
            drops[i] += 1;
            if (drops[i] >= HEIGHT) {
                drops[i] = 0;
            }
        }

        usleep(50000); // 50ms
    }

    return 0;
}
