const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");
const path = require("path");
const fs = require("fs");

const app = express();
const port = 3000;
const pathPrefix = "/de-game";

// Middleware
app.use(cors());
app.use(express.json());

// Determine if we're running in a packaged environment
const isPackaged = process.pkg;
const publicPath = isPackaged
  ? path.join(process.execPath, "..", "public")
  : path.join(__dirname, "public");

// Ensure public directory exists in packaged environment
if (isPackaged && !fs.existsSync(publicPath)) {
  fs.mkdirSync(publicPath, { recursive: true });
}

app.use(pathPrefix, express.static(publicPath));

// Read contract address from config
let config;
try {
  // Try to read config from the same directory as the executable first
  const configPath = isPackaged 
    ? path.join(process.execPath, "..", "config.json")
    : path.join(__dirname, "config.json");
  
  if (fs.existsSync(configPath)) {
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  } else {
    // Fallback to public directory
    const publicConfigPath = path.join(publicPath, "config.json");
    if (fs.existsSync(publicConfigPath)) {
      config = JSON.parse(fs.readFileSync(publicConfigPath, 'utf8'));
    } else {
      throw new Error("config.json not found");
    }
  }
} catch (error) {
  console.error("Error loading config:", error);
  process.exit(1);
}

// Provider setup
const provider = new ethers.providers.JsonRpcProvider(config.providerUrl);
const factoryContractAddress = config.factoryContractAddress;

const factoryContractAbi = require("../smart-contract/RouletteGameFactory_abi.json");
const gameContractAbi = require("../smart-contract/RouletteGame_abi.json");

// Read-only contract instance
const contract = new ethers.Contract(
  factoryContractAddress,
  factoryContractAbi,
  provider
);

// Root route - redirect to factory
app.get("/", (req, res) => {
  res.redirect(`${pathPrefix}/factory.html`);
});

// Factory page route
app.get(`${pathPrefix}/factory.html`, (req, res) => {
  res.sendFile(path.join(publicPath, "factory.html"));
});

// Game page route with validation
app.get(`${pathPrefix}/game.html`, (req, res) => {
  const address = req.query.address;

  if (!address) {
    // Redirect to factory if no address provided
    res.redirect(`${pathPrefix}/factory.html`);
    return;
  }

  // Validate Ethereum address
  if (!ethers.utils.isAddress(address)) {
    res.status(400).send("Invalid Ethereum address");
    return;
  }

  // Send the game page
  res.sendFile(path.join(publicPath, "game.html"));
});

app.get(`${pathPrefix}/api/games`, async (req, res) => {
  try {
    const games = await contract.getAllGames();
    res.json({ success: true, games });
  } catch (error) {
    console.error("Error fetching games:", error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get(`${pathPrefix}/api/contract-info`, (req, res) => {
  if (req.query.module === "factory") {
    res.json({
      success: true,
      records: [
        {
          address: factoryContractAddress,
          abi: factoryContractAbi,
        },
      ],
    });
  } else if (req.query.module === "game") {
    res.json({
      success: true,
      records: [
        {
          abi: gameContractAbi,
        },
      ],
    });
  } else {
    res.status(404).json({ success: false, error: "Not found" });
  }
});

// Get all events for a given contract address
app.get(`${pathPrefix}/api/events`, async (req, res) => {
  try {
    const { address, fromBlock = 0, toBlock = "latest" } = req.query;

    if (!address) {
      return res.status(400).json({
        success: false,
        error: "Contract address is required",
      });
    }

    if (!ethers.utils.isAddress(address)) {
      return res.status(400).json({
        success: false,
        error: "Invalid contract address",
      });
    }

    // Create contract instance with the provided address
    const contract = new ethers.Contract(address, gameContractAbi, provider);

    // Get all events
    const events = await contract.queryFilter({}, fromBlock, toBlock);

    // Format events for response
    const formattedEvents = events.map((event) => ({
      event: event.event,
      args: event.args,
      blockNumber: event.blockNumber,
      transactionHash: event.transactionHash,
      address: event.address,
      timestamp: event.timestamp,
    }));

    res.json({
      success: true,
      events: formattedEvents,
    });
  } catch (error) {
    console.error("Error fetching events:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}${pathPrefix}`);
  console.log(`Using config from: ${isPackaged ? 'packaged executable directory' : 'development directory'}`);
});
