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
    ? path.join(process.execPath, '..', 'public')
    : path.join(__dirname, 'public');

// Ensure public directory exists in packaged environment
if (isPackaged && !fs.existsSync(publicPath)) {
    fs.mkdirSync(publicPath, { recursive: true });
}

app.use(pathPrefix, express.static(publicPath));

// Provider setup
const provider = new ethers.providers.JsonRpcProvider(
  `https://eth-sepolia.g.alchemy.com/v2/KzMo6mqHA6-Re4Q0ayDrSW0XaR9bfymY`
);

const factoryContractAddress = "0x0d66f967a3f1EE4d4d5BF61d658d089dA10Dd7eB";
const factoryContractABI = require("../smart-contract/RouletteGameFactory_abi.json");

const gameContractAbi = require("../smart-contract/RouletteGame_abi.json");

// Read-only contract instance
const contract = new ethers.Contract(
  factoryContractAddress,
  factoryContractABI,
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
          abi: factoryContractABI,
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
        error: "Contract address is required" 
      });
    }

    if (!ethers.utils.isAddress(address)) {
      return res.status(400).json({ 
        success: false, 
        error: "Invalid contract address" 
      });
    }

    // Create contract instance with the provided address
    const contract = new ethers.Contract(address, gameContractAbi, provider);

    // Get all events
    const events = await contract.queryFilter({}, fromBlock, toBlock);

    // Format events for response
    const formattedEvents = events.map(event => ({
      event: event.event,
      args: event.args,
      blockNumber: event.blockNumber,
      transactionHash: event.transactionHash,
      address: event.address,
      timestamp: event.timestamp
    }));

    res.json({ 
      success: true, 
      events: formattedEvents 
    });
  } catch (error) {
    console.error("Error fetching events:", error);
    res.status(500).json({ 
      success: false, 
      error: error.message 
    });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}${pathPrefix}`);
});
