cat <<EOF > tetris.c
#include <stdio.h>
#include <conio.h>
#include <dos.h>

#define WIDTH 10
#define HEIGHT 20

char grid[HEIGHT][WIDTH];  // Tetris grid
int score = 0;  // Player score

// Draw the grid to the screen
void drawGrid() {
    clrscr();
    printf("TETRIS - Graphing Calculator Style\nScore: %d\n\n", score);

    for (int i = 0; i < HEIGHT; i++) {
        printf("|");
        for (int j = 0; j < WIDTH; j++) {
            if (grid[i][j] == 1) {
                printf("# ");
            } else {
                printf(". ");
            }
        }
        printf("|\n");
    }
    printf("====================\n");
}

// Clear the grid (set all cells to empty)
void clearGrid() {
    for (int i = 0; i < HEIGHT; i++)
        for (int j = 0; j < WIDTH; j++)
            grid[i][j] = 0;
}

// Place a block on the grid
void placeBlock(int x, int y) {
    grid[y][x] = 1;
}

// Move the block down; checks for collision
int moveBlock(int *x, int *y) {
    if (*y < HEIGHT - 1 && grid[*y + 1][*x] == 0) {
        grid[*y][*x] = 0;  // Clear old position
        (*y)++;
        grid[*y][*x] = 1;  // Place new position
        return 1;
    }
    return 0;
}

// Check for full lines and clear them
void clearFullLines() {
    for (int i = 0; i < HEIGHT; i++) {
        int fullLine = 1;
        for (int j = 0; j < WIDTH; j++) {
            if (grid[i][j] == 0) {
                fullLine = 0;
                break;
            }
        }

        if (fullLine) {
            // Clear the line
            for (int j = 0; j < WIDTH; j++) {
                grid[i][j] = 0;
            }

            // Shift all lines down
            for (int k = i; k > 0; k--) {
                for (int j = 0; j < WIDTH; j++) {
                    grid[k][j] = grid[k - 1][j];
                }
            }

            // Increment score
            score += 100;
        }
    }
}

int main() {
    int x = WIDTH / 2, y = 0;  // Start in the middle
    char key;

    clearGrid();
    placeBlock(x, y);
    drawGrid();

    while (1) {
        if (kbhit()) {
            key = getch();
            if (key == 27) break;  // Escape key exits
            if (key == 'a' && x > 0) x--;  // Move Left
            if (key == 'd' && x < WIDTH-1) x++;  // Move Right
            if (key == 's') moveBlock(&x, &y);  // Move Down
        }

        delay(300);  // Slow down movement
        if (!moveBlock(&x, &y)) {
            clearFullLines();  // Clear lines if full
            placeBlock(x, y);  // Place new block at top
        }

        drawGrid();  // Redraw the grid
    }

    return 0;
}
EOF
