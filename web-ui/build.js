const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Create dist directory if it doesn't exist
const distDir = path.join(__dirname, 'dist');
if (!fs.existsSync(distDir)) {
    fs.mkdirSync(distDir);
}

// Install dependencies
console.log('Installing dependencies...');
execSync('npm install', { stdio: 'inherit' });

// Build the executable
console.log('Building executable...');
execSync('npm run build', { stdio: 'inherit' });

// Copy the executable to dist
console.log('Copying files to dist directory...');
fs.copyFileSync(path.join(__dirname, 'roulette-app.exe'), path.join(distDir, 'roulette-app.exe'));

// Copy the public folder to dist
console.log('Copying public folder to dist directory...');
const publicDir = path.join(__dirname, 'public');
const distPublicDir = path.join(distDir, 'public');

// Create public directory in dist if it doesn't exist
if (!fs.existsSync(distPublicDir)) {
    fs.mkdirSync(distPublicDir, { recursive: true });
}

// Function to copy directory recursively
function copyDir(src, dest) {
    const entries = fs.readdirSync(src, { withFileTypes: true });
    
    for (const entry of entries) {
        const srcPath = path.join(src, entry.name);
        const destPath = path.join(dest, entry.name);
        
        if (entry.isDirectory()) {
            fs.mkdirSync(destPath, { recursive: true });
            copyDir(srcPath, destPath);
        } else {
            fs.copyFileSync(srcPath, destPath);
        }
    }
}

// Copy the public directory
copyDir(publicDir, distPublicDir);

// Copy config.json to dist directory
console.log('Copying config.json to dist directory...');
const configPath = path.join(__dirname, 'config.json');
if (fs.existsSync(configPath)) {
    // Copy config.json to both root and public directory
    fs.copyFileSync(configPath, path.join(distDir, 'config.json'));
    fs.copyFileSync(configPath, path.join(distPublicDir, 'config.json'));
} else {
    console.warn('Warning: config.json not found in source directory');
}

// Create a README file
const readmeContent = `# Roulette Game Application

This is a standalone executable version of the Roulette Game application.

## How to Run

1. Double-click on 'roulette-app.exe'
2. The application will start and be available at http://localhost:3000/de-game

## Configuration

The application uses config.json for contract configuration. You can modify the config.json file in the same directory as the executable to change contract settings.

## Requirements

- Windows 10 or later
- No Node.js installation required

## Note

This application is for academic and research purposes only. It is not intended for actual gambling or real-money transactions.
`;

fs.writeFileSync(path.join(distDir, 'README.txt'), readmeContent);

console.log('Build completed successfully!');
console.log(`The packaged application is available in the 'dist' directory.`); 