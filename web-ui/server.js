const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");
const path = require("path");

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static("public"));

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
  res.redirect("/factory.html");
});

// Factory page route
app.get("/factory.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "factory.html"));
});

// Game page route with validation
app.get("/game.html", (req, res) => {
  const address = req.query.address;

  if (!address) {
    // Redirect to factory if no address provided
    res.redirect("/factory.html");
    return;
  }

  // Validate Ethereum address
  if (!ethers.utils.isAddress(address)) {
    res.status(400).send("Invalid Ethereum address");
    return;
  }

  // Send the game page
  res.sendFile(path.join(__dirname, "public", "game.html"));
});

app.get("/api/games", async (req, res) => {
  try {
    const games = await contract.getAllGames();
    res.json({ success: true, games });
  } catch (error) {
    console.error("Error fetching games:", error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get("/api/contract-info", (req, res) => {
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

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
