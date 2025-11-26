import chalk from "chalk";
import gradient from "gradient-string";
import inquirer from "inquirer";
import figlet from "figlet";
import * as fs from "fs";
import * as path from "path";

// Utility sleep
const wait = (ms: number) => new Promise(r => setTimeout(r, ms));

function bigTitle(text: string) {
    console.log(gradient.pastel.multiline(figlet.textSync(text, { horizontalLayout: "full" })));
}

async function loadingBar(speedMB: number, maxGB: number) {
    let current = 0;
    let max = maxGB * 1024; // convert to MB

    while (current < max) {
        current += speedMB;
        const percent = Math.min(100, (current / max) * 100);
        const blocks = Math.floor(percent / 2);
        const bar = chalk.green("█".repeat(blocks)) + chalk.gray("░".repeat(50 - blocks));
        process.stdout.write(`\r${bar} ${percent.toFixed(2)}% (${(current / 1024).toFixed(2)} GB / ${maxGB} GB)`);
        await wait(300);
    }
    console.log("\n");
}

async function createChaosFiles() {
    const dir = path.join(process.cwd(), "C_MODE_OUTPUT");
    if (!fs.existsSync(dir)) fs.mkdirSync(dir);

    const files = [];
    for (let i = 1; i <= 50; i++) {
        const name = `phase_${i}_C_MODE_${Math.random().toString(36).slice(2)}.txt`;
        const filePath = path.join(dir, name);
        fs.writeFileSync(filePath, `C-MODE FILE #${i}\nGenerated at: ${new Date().toISOString()}`);
        files.push(name);
        console.log(chalk.cyan(`Created: ${name}`));
        await wait(60);
    }
}

async function chaosEvents() {
    console.log(gradient.morning("⚡ Initiating CHAOS EVENTS..."));

    const events = [
        "📡 Scanning system frequencies...",
        "🧬 Rebuilding digital DNA...",
        "🌀 Opening quantum tunnel...",
        "🔥 Boosting CPU virtual flames...",
        "🧨 Deploying fake payload packets...",
        "🛰️ Connecting to imaginary satellites...",
        "🚀 Launching hypermode...",
        "🌐 Encrypting imaginary data streams...",
        "🎮 Leveling up chaos engine...",
        "💫 Reality Distortion Field: ON"
    ];

    for (const e of events) {
        console.log(chalk.yellow(e));
        await wait(500);
    }
}

async function phaseLeveling() {
    console.log(gradient.retro("📊 LEVELING SYSTEM ENGAGED"));

    let level = 1;
    for (let xp = 0; xp <= 100; xp += 5) {
        process.stdout.write(`\rLevel ${level} | XP: ${xp}/100`);
        await wait(200);
        if (xp === 100) {
            console.log(`\n${chalk.green("LEVEL UP!")} → ${++level}`);
            xp = 0;
            await wait(500);
        }
        if (level > 5) break;
    }
}

async function fakeInstaller() {
    console.log(gradient.summer("💿 Starting Hyper-Installer v9.9..."));
    await wait(700);
    await loadingBar(3.5, 2.1);
    console.log(chalk.green("✔ Installation Complete (Simulation Only)"));
}

async function chaosMenu() {
    bigTitle("C-MODE");

    const first = await inquirer.prompt([
        {
            name: "start",
            type: "list",
            message: "Start CHAOS SYSTEM?",
            choices: ["YES - Enter C Mode", "NO - I'm Scared"]
        }
    ]);

    if (first.start.includes("NO")) {
        console.log(chalk.red("💀 Coward detected. Exiting..."));
        return;
    }

    bigTitle("BOOT");
    console.log(gradient.atlas("Initializing C-MODE Operating Core..."));
    await wait(1200);

    await fakeInstaller();

    await inquirer.prompt([{ name: "c", type: "confirm", message: "Continue to Phase Creation?" }]);

    bigTitle("PHASES");
    await createChaosFiles();

    await inquirer.prompt([{ name: "c", type: "confirm", message: "Continue to Chaos Events?" }]);

    bigTitle("CHAOS");
    await chaosEvents();

    await inquirer.prompt([{ name: "c", type: "confirm", message: "Continue to Leveling Engine?" }]);

    bigTitle("LEVEL UP");
    await phaseLeveling();

    bigTitle("COMPLETE");
    console.log(gradient.fruit("🌈 C-MODE Successfully Simulated.\nAll systems stable."));
    console.log(chalk.green("Your chaos files are inside: ./C_MODE_OUTPUT"));
}

chaosMenu();
