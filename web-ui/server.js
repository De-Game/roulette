const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static("public"));

// Redirect root to factory.html
app.get('/', (req, res) => {
    res.redirect('/factory.html');
});

// Provider setup
const provider = new ethers.providers.JsonRpcProvider(
  `https://eth-sepolia.g.alchemy.com/v2/KzMo6mqHA6-Re4Q0ayDrSW0XaR9bfymY`
);

const factoryContractAddress = "0x0d66f967a3f1EE4d4d5BF61d658d089dA10Dd7eB";
const factoryContractABI = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "contractAddress",
        type: "address",
      },
    ],
    name: "GameCreated",
    type: "event",
  },
  {
    inputs: [],
    name: "count",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_host",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_minBet",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_minDeposit",
        type: "uint256",
      },
      {
        internalType: "address[]",
        name: "_validators",
        type: "address[]",
      },
      {
        internalType: "uint8",
        name: "_validThreshold",
        type: "uint8",
      },
    ],
    name: "create",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getAllGames",
    outputs: [
      {
        internalType: "address[]",
        name: "",
        type: "address[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

// Read-only contract instance
const contract = new ethers.Contract(
  factoryContractAddress,
  factoryContractABI,
  provider
);

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
  } else {
    res.status(404).json({ success: false, error: "Not found" });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
