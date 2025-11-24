#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    printf("Critical error occurred...\n");
    printf("Out of memory\n");
    _sleep(3000);
    system("cls");
    printf("Retrying...\n");
    printf("[                                                                                                    ]");
    for (int i = 0; i < 101; i++) {
        printf("\r[");
        for (int j = 0; j < i; j++) {
            printf("#");
        }
        int diff = 100 - i;
        for (int k = 0; k < diff; k++) {
            printf(" ");
        }
        printf("] %i/100%%", i);
        _sleep(100);
    }
    printf("\n");
    _sleep(5000);
    system("cls");
    printf("Test failed...\nSystem will destroy itself in three...\n");
    _sleep(1000);
    printf("Two...\n");
    _sleep(1000);
    printf("One...\n");
    _sleep(1000);
    printf("FAILED\n");
    _sleep(3000);
    return 0;
}