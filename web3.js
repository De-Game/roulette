const { ethers } = require("ethers");

// Step 1: Connect to the Sepolia network
const provider = new ethers.providers.JsonRpcProvider(`https://eth-sepolia.g.alchemy.com/v2/KzMo6mqHA6-Re4Q0ayDrSW0XaR9bfymY`);

// Step 2: Define the contract's ABI and address
const abi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "finalValue",
				"type": "string"
			}
		],
		"name": "set",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "get",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
const contractAddress = "0xb1E0d02513477310307333bc4ceAF85FB6daf1FB";

// Step 3: Create a contract instance
const contract = new ethers.Contract(contractAddress, abi, provider);

// Step 4: Call the get function
async function callGetFunction() {
    try {
        const result = await contract.get();
        console.log("Result from contract:", result);
    } catch (error) {
        console.error("Error calling contract function:", error);
    }
}

// Execute the function
callGetFunction();