let signer = null;
let provider = null;
let factoryContract = null;
let currentWallet = null;

let factoryContractAddress = null;
let factoryContractAbi = null;

function copyToClipboard(text) {
    debugger
  navigator.clipboard
    .writeText(text)
    .then(() => {
      alert("Address copied to clipboard!");
    })
    .catch((err) => {
      console.error("Error copying text: ", err);
    });
}

async function getContractInfo() {
  try {
    const response = await fetch("/api/contract-info?module=factory");
    const result = await response.json();
    let contractInfo = result.records[0];
    factoryContractAddress = contractInfo.address;
    factoryContractAbi = contractInfo.abi;
  } catch (error) {
    console.error("Error fetching contract info:", error);
    return null;
  }
}

async function connectWallet() {
  try {
    if (!window.ethereum) {
      alert("Please install MetaMask!");
      return;
    }

    provider = new ethers.providers.Web3Provider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts", []);
    currentWallet = accounts[0];
    document.getElementById("walletAddress").textContent = currentWallet;

    // Initialize contract instance
    signer = provider.getSigner();
    factoryContract = new ethers.Contract(
      factoryContractAddress,
      factoryContractAbi,
      signer
    );
  } catch (error) {
    console.error("Error connecting wallet:", error);
    alert("Error connecting wallet: " + error.message);
  }
}

async function createContract(event) {
  event.preventDefault();

  if (!currentWallet || !factoryContract) {
    alert("Please connect your wallet first!");
    return;
  }

  const host = document.getElementById("host").value.trim();
  const minBet = document.getElementById("minBet").value;
  const minDeposit = document.getElementById("minDeposit").value;
  const validators = document.getElementById("validators").value;
  const validThreshold = document.getElementById("validThreshold").value;

  try {
    // Validate host address if provided
    let hostAddress = currentWallet; // Default to current wallet
    if (host) {
      if (!ethers.utils.isAddress(host)) {
        throw new Error("Invalid host address format");
      }
      hostAddress = host;
    }

    // Convert values to appropriate units
    const minBetWei = ethers.utils.parseEther(minBet.toString());
    const minDepositWei = ethers.utils.parseEther(minDeposit.toString());
    const validatorAddresses = validators.split(",").map((addr) => addr.trim());
    const validThresholdNumber = parseInt(validThreshold);

    // Validate inputs
    if (!validatorAddresses.every((addr) => ethers.utils.isAddress(addr))) {
      throw new Error("Invalid validator address format");
    }

    if (validThresholdNumber < 1 || validThresholdNumber > 255) {
      throw new Error("Valid threshold must be between 1 and 255");
    }

    console.log("hostAddress", hostAddress);
    console.log("minBetWei", minBetWei);
    console.log("minDepositWei", minDepositWei);
    console.log("validatorAddresses", validatorAddresses);
    console.log("validThresholdNumber", validThresholdNumber);

    // Show loading state
    const submitButton = document.querySelector(
      '#createContractForm button[type="submit"]'
    );
    submitButton.disabled = true;
    submitButton.classList.add("loading");
    submitButton.textContent = "Creating Contract...";

    // Call the contract directly
    const tx = await factoryContract.create(
      hostAddress,
      minBetWei,
      minDepositWei,
      validatorAddresses,
      validThresholdNumber
    );

    // Wait for transaction to be mined
    const receipt = await tx.wait();

    // Get the created contract address from the event
    const event = receipt.events.find((e) => e.event === "GameCreated");
    const contractAddress = event.args.contractAddress;

    alert(
      `Contract deployed successfully!\nAddress: ${contractAddress}\nTransaction: ${receipt.transactionHash}`
    );

    // Refresh the contracts list
    loadContracts();
  } catch (error) {
    console.error("Error deploying contract:", error);
    alert("Error deploying contract: " + error.message);
  } finally {
    // Reset button state
    const submitButton = event.target.querySelector('button[type="submit"]');
    submitButton.disabled = false;
    submitButton.classList.remove("loading");
    submitButton.textContent = "Create Contract";
  }
}

async function loadContracts() {
  try {
    const response = await fetch("/api/games");
    const result = await response.json();

    const contractsList = document.getElementById("contractsList");
    contractsList.innerHTML = ""; // Clear existing list

    if (result.success && result.games.length > 0) {
      result.games.forEach((contractAddress) => {
        const contractItem = document.createElement("div");
        contractItem.className = "list-group-item";
        contractItem.innerHTML = `
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="font-monospace">${contractAddress}</span>
                        <button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard('${contractAddress}')">
                            Copy Address
                        </button>
                    </div>
                `;
        contractsList.appendChild(contractItem);
      });
    } else {
      contractsList.innerHTML =
        '<div class="list-group-item">No contracts available</div>';
    }
  } catch (error) {
    console.error("Error loading contracts:", error);
    document.getElementById("contractsList").innerHTML =
      '<div class="list-group-item text-danger">Error loading contracts</div>';
  }
}



// Event Listeners
document.addEventListener("DOMContentLoaded", async () => {
  await getContractInfo();
  // Add event listeners
  document
    .getElementById("connectWallet")
    .addEventListener("click", connectWallet);
  document
    .getElementById("createContractForm")
    .addEventListener("submit", createContract);

  // Load initial contracts
  loadContracts();
});

// Listen for account changes
if (window.ethereum) {
  window.ethereum.on("accountsChanged", async (accounts) => {
    if (accounts.length > 0) {
      await connectWallet();
    } else {
      document.getElementById("walletAddress").textContent = "";
      currentWallet = null;
      signer = null;
      provider = null;
      factoryContract = null;
    }
  });

  // Listen for chain changes
  window.ethereum.on("chainChanged", () => {
    window.location.reload();
  });
}
