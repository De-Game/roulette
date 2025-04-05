const { ethers } = require("ethers");

// Step 1: Connect to the Sepolia network
const provider = new ethers.providers.JsonRpcProvider(`https://eth-sepolia.g.alchemy.com/v2/KzMo6mqHA6-Re4Q0ayDrSW0XaR9bfymY`);

const contractAddress = "0x0d66f967a3f1EE4d4d5BF61d658d089dA10Dd7eB";
const contractABI = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "contractAddress",
				"type": "address"
			}
		],
		"name": "GameCreated",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "count",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_host",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_minBet",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minDeposit",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "_validators",
				"type": "address[]"
			},
			{
				"internalType": "uint8",
				"name": "_validThreshold",
				"type": "uint8"
			}
		],
		"name": "create",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAllGames",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

let signer = null;
let contract = null;

async function connectWallet() {
	try {
		// Request account access
		await window.ethereum.request({ method: 'eth_requestAccounts' });
		
		// Create Web3Provider and get signer
		const provider = new ethers.providers.Web3Provider(window.ethereum);
		signer = provider.getSigner();
		
		// Get and display the connected address
		const address = await signer.getAddress();
		document.getElementById('walletAddress').textContent = `Connected: ${address.substring(0, 6)}...${address.substring(38)}`;
		
		// Create contract instance
		contract = new ethers.Contract(contractAddress, contractABI, signer);
		
		// Load existing games
		await loadGames();
		
		return true;
	} catch (error) {
		console.error('Error connecting wallet:', error);
		alert('Failed to connect wallet. Please make sure MetaMask is installed and try again.');
		return false;
	}
}

async function loadGames() {
	try {
		const games = await contract.getAllGames();
		const gameList = document.getElementById('gameList');
		gameList.innerHTML = '';
		
		games.forEach((game, index) => {
			const gameElement = document.createElement('div');
			gameElement.className = 'card mb-2';
			gameElement.innerHTML = `
				<div class="card-body">
					<h6 class="card-subtitle mb-2">Game ${index + 1}</h6>
					<p class="card-text">Address: ${game}</p>
				</div>
			`;
			gameList.appendChild(gameElement);
		});
	} catch (error) {
		console.error('Error loading games:', error);
		alert('Failed to load games. Please try again.');
	}
}

async function createGame(event) {
	event.preventDefault();
	
	if (!signer) {
		alert('Please connect your wallet first.');
		return;
	}
	
	try {
		const minBet = ethers.utils.parseEther(document.getElementById('minBet').value);
		const minDeposit = ethers.utils.parseEther(document.getElementById('minDeposit').value);
		const validatorsInput = document.getElementById('validators').value;
		const validators = validatorsInput.split(',').map(addr => addr.trim());
		const validThreshold = parseInt(document.getElementById('validThreshold').value);
		
		const userAddress = await signer.getAddress();
		
		const tx = await contract.create(
			userAddress,
			minBet,
			minDeposit,
			validators,
			validThreshold
		);
		
		alert('Transaction submitted. Please wait for confirmation...');
		await tx.wait();
		
		alert('Game created successfully!');
		await loadGames();
		
		// Reset form
		document.getElementById('createGameForm').reset();
	} catch (error) {
		console.error('Error creating game:', error);
		alert('Failed to create game. Please check the console for details.');
	}
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
	document.getElementById('connectWallet').addEventListener('click', connectWallet);
	document.getElementById('createGameForm').addEventListener('submit', createGame);
});

// Listen for account changes
if (window.ethereum) {
	window.ethereum.on('accountsChanged', async (accounts) => {
		if (accounts.length > 0) {
			await connectWallet();
		} else {
			document.getElementById('walletAddress').textContent = '';
			signer = null;
			contract = null;
		}
	});
}