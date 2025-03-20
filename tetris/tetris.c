#include <stdio.h>
#include <conio.h>
#include <dos.h>

#define WIDTH 10
#define HEIGHT 20

char grid[HEIGHT][WIDTH]; // Tetris Grid
int score = 0; // Player Score

// Function to draw the game grid
void drawGrid() {
    clrscr();
    printf("TETRIS - Graphing Calculator Style\nScore: %d\n\n", score);

    for (int i = 0; i < HEIGHT; i++) {
        printf("|");
        for (int j = 0; j < WIDTH; j++) {
            printf(grid[i][j] ? "# " : ". ");
        }
        printf("|\n");
    }
    printf("====================\n");
}

// Function to clear the grid
void clearGrid() {
    for (int i = 0; i < HEIGHT; i++)
        for (int j = 0; j < WIDTH; j++)
            grid[i][j] = 0;
}

// Function to place a block
void placeBlock(int x, int y) {
    grid[y][x] = 1;
}

// Function to move the block down (checks for collisions)
int moveBlock(int *x, int *y) {
    if (*y < HEIGHT - 1 && grid[*y + 1][*x] == 0) {
        grid[*y][*x] = 0; // Clear old position
        (*y)++;
        grid[*y][*x] = 1; // Place new position
        return 1;
    }
    return 0; // Can't move down
}

// Function to check for and clear full lines
void clearFullLines() {
    for (int i = 0; i < HEIGHT; i++) {
        int full = 1;
        for (int j = 0; j < WIDTH; j++) {
            if (grid[i][j] == 0) {
                full = 0;
                break;
            }
        }
        if (full) {
            // Clear the line
            for (int j = 0; j < WIDTH; j++) {
                grid[i][j] = 0;
            }
            // Shift everything down
            for (int k = i; k > 0; k--) {
                for (int j = 0; j < WIDTH; j++) {
                    grid[k][j] = grid[k - 1][j];
                }
            }
            score += 100; // Increase score for clearing a line
        }
    }
}

// Main Game Loop
int main() {
    int x = WIDTH / 2, y = 0; // Start in the middle
    char key;

    clearGrid();
    placeBlock(x, y);
    drawGrid();

    while (1) {
        if (kbhit()) {
            key = getch();
            if (key == 27) break;  // Escape key exits
            if (key == 'a' && x > 0) x--;  // Move left
            if (key == 'd' && x < WIDTH-1) x++;  // Move right
            if (key == 's') moveBlock(&x, &y);  // Move down faster
        }

        delay(300); // Slow down movement
        if (!moveBlock(&x, &y)) {
            clearFullLines(); // Check if a line is full
            placeBlock(x, y); // Place a new block at the top
        }

        drawGrid(); // Redraw the screen
    }

    return 0;
}
