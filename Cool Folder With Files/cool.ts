// A clean TypeScript terminal animation with no Node APIs

let x = 0;
let y = 0;
let dx = 1;
let dy = 1;

const width = 40;
const height = 15;
const text = "★ COOL ANIMATION ★";

function draw() {
    let screen = "";

    for (let row = 0; row < height; row++) {
        let line = "";
        for (let col = 0; col < width; col++) {
            if (row === y && col === x) {
                line += text;
                col += text.length - 1;
            } else {
                line += " ";
            }
        }
        screen += line + "\n";
    }

    // clear and print frame
    console.clear();
    console.log(screen);

    // move
    x += dx;
    y += dy;

    // bounce horizontally
    if (x <= 0 || x + text.length >= width) dx = -dx;

    // bounce vertically
    if (y <= 0 || y >= height - 1) dy = -dy;
}

// 30 FPS
setInterval(draw, 33);
