let signer = null;
let provider = null;
let gameContract = null;
let currentWallet = null;
let selectedNumber = null;
let selectedBetType = null;

// Get contract address from URL
const urlParams = new URLSearchParams(window.location.search);
const contractAddress = urlParams.get("address");

if (!contractAddress) {
  window.location.href = "/de-game/factory.html";
}

// Game status constants
const GAME_STATUS = {
  0: {
    text: "Pending Host Deposit",
    class: "status-pending",
    description: "Waiting for the host to deposit funds to start the game.",
  },
  1: {
    text: "Accepting Bets",
    class: "status-active",
    description: "Game is active and accepting bets from players.",
  },
  2: {
    text: "No More Bets",
    class: "status-pending",
    description: "Betting period has ended. Waiting for result generation.",
  },
  3: {
    text: "Result Generated",
    class: "status-pending",
    description: "Result has been generated. Waiting for validation.",
  },
  4: {
    text: "Result Validated",
    class: "status-finished",
    description: "Result has been validated. Winnings can be claimed.",
  },
  5: {
    text: "Game Canceled",
    class: "status-canceled",
    description: "Game has been canceled. Refunds can be claimed.",
  },
  6: {
    text: "Game Finished",
    class: "status-finished",
    description: "Game has been completed successfully.",
  },
};

// Initialize the game
async function initGame() {
  try {
    // Display contract address
    document.getElementById("contractAddress").textContent = contractAddress;

    // Load contract ABI
    const response = await fetch("/de-game/api/contract-info?module=game");
    const result = await response.json();
    const gameContractAbi = result.records[0].abi;

    // Initialize contract
    provider = new ethers.providers.Web3Provider(window.ethereum);
    gameContract = new ethers.Contract(
      contractAddress,
      gameContractAbi,
      provider
    );

    // Load game info
    await loadGameInfo();

    // Initialize number grid
    initNumberGrid();

    // Add event listeners
    document
      .getElementById("connectWallet")
      .addEventListener("click", connectWallet);
    document.getElementById("placeBet").addEventListener("click", placeBet);
    document.getElementById("betAmount").addEventListener("input", validateBet);

    // Add bet type button listeners
    document.querySelectorAll(".bet-type-btn").forEach((button) => {
      button.addEventListener("click", () => selectBetType(button));
    });

    // Listen for account changes
    if (window.ethereum) {
      window.ethereum.on("accountsChanged", handleAccountsChanged);
      window.ethereum.on("chainChanged", handleChainChanged);
    }

    // Add bet amount input listener
    document.getElementById("betAmount").addEventListener("input", () => {
      updateBetAmountDisplay();
      validateBet();
    });

    // Add max bet button listener
    document.getElementById("maxBetBtn").addEventListener("click", () => {
      const maxBet = parseFloat(document.getElementById("maxBet").textContent);
      document.getElementById("betAmount").value = maxBet;
      updateBetAmountDisplay();
      validateBet();
    });

    // Add host deposit input listener
    document
      .getElementById("hostDepositAmountInput")
      .addEventListener("input", validateDeposit);

    // Add make deposit button listener
    document
      .getElementById("makeDeposit")
      .addEventListener("click", makeDeposit);

    // Add generate result button listener
    document
      .getElementById("generateResult")
      .addEventListener("click", generateResult);

    // Add validation button listeners
    document
      .getElementById("validateResult")
      .addEventListener("click", validateResult);

    // Listen for status changes
    /*gameContract.on('StatusChanged', (newStatus) => {
      updateGameStatus(newStatus);
    });*/
  } catch (error) {
    console.error("Error initializing game:", error);
    alert("Error initializing game: " + error.message);
  }
}

// Load game information
async function loadGameInfo() {
  try {
    // Get minimum bet
    const minBet = await gameContract.minBet();
    document.getElementById("minBet").textContent =
      ethers.utils.formatEther(minBet) + " ETH";

    // Get maximum bet
    const maxBet = await gameContract.maxBet();
    document.getElementById("maxBet").textContent =
      ethers.utils.formatEther(maxBet) + " ETH";

    // Get minimum deposit
    const minDeposit = await gameContract.minDeposit();
    document.getElementById("minDepositAmount").textContent =
      ethers.utils.formatEther(minDeposit) + " ETH";

    // Get game status
    const status = await gameContract.status();
    updateGameStatus(status);

    // Get host deposit
    document.getElementById("hostDepositStatusText").textContent =
      status < 1 ? "Not Deposited" : "Deposited";

    // Get and display result if available
    const result = await gameContract.result();
    const lastResultElement = document.getElementById("lastResult");

    if (result > 0) {
      // Format the result number (00 is represented as 37 in the contract)
      const displayResult = result === 37 ? "00" : result.toString();
      lastResultElement.textContent = displayResult;

      // Add color class based on the result
      lastResultElement.className = "deposit-amount";
      if (result === 0 || result === 37) {
        lastResultElement.classList.add("text-success"); // Green for 0 and 00
      } else if (
        [
          1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36,
        ].includes(result)
      ) {
        lastResultElement.classList.add("text-danger"); // Red numbers
      } else {
        lastResultElement.classList.add("text-dark"); // Black numbers
      }
    } else {
      lastResultElement.textContent = "-";
      lastResultElement.className = "deposit-amount";
    }

    // Update player balance if wallet is connected
    if (currentWallet) {
      const balance = await provider.getBalance(currentWallet);
      document.getElementById("playerBalance").textContent =
        ethers.utils.formatEther(balance) + " ETH";
    }

    // Get validation info
    const validatorThreshold = await gameContract.validatorThreshold();
    const approvedValidatorsCount = "TBC";

    const validatorCountElement = document.getElementById("validatorCount");

    // Update validator count
    validatorCountElement.textContent = `${approvedValidatorsCount}/${validatorThreshold}`;
  } catch (error) {
    console.error("Error loading game info:", error);
  }
}

// Initialize number grid
function initNumberGrid() {
  const grid = document.getElementById("numberGrid");
  grid.innerHTML = "";

  // Create numbers 0-36 first
  for (let i = 0; i <= 36; i++) {
    const button = document.createElement("button");
    button.className = "number-btn";
    button.textContent = i;

    // Add color classes for red and black numbers
    if (i === 0) {
      button.classList.add("green");
    } else if (
      [
        1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36,
      ].includes(i)
    ) {
      button.classList.add("red");
    } else {
      button.classList.add("black");
    }

    button.addEventListener("click", () => selectNumber(button, i));
    grid.appendChild(button);
  }

  // Create 00 button last
  const doubleZeroButton = document.createElement("button");
  doubleZeroButton.className = "number-btn green";
  doubleZeroButton.textContent = "00";
  doubleZeroButton.addEventListener("click", () =>
    selectNumber(doubleZeroButton, "00")
  );
  grid.appendChild(doubleZeroButton);
}

// Select a number
function selectNumber(button, number) {
  // Remove selection from all bet options
  document.querySelectorAll(".number-btn, .bet-type-btn").forEach((btn) => {
    btn.classList.remove("selected");
  });

  // Select new number with animation
  button.classList.add("selected");
  selectedNumber = number;
  selectedBetType = null; // Clear bet type selection

  // Update bet amount display
  updateBetAmountDisplay();
  validateBet();
}

// Select bet type
function selectBetType(button) {
  // Remove selection from all bet options
  document.querySelectorAll(".number-btn, .bet-type-btn").forEach((btn) => {
    btn.classList.remove("selected");
  });

  // Select new bet type with animation
  button.classList.add("selected");
  selectedBetType = button.dataset.type;
  selectedNumber = null; // Clear number selection

  // Update bet amount display
  updateBetAmountDisplay();
  validateBet();
}

// Update bet amount display
function updateBetAmountDisplay() {
  const betAmount = document.getElementById("betAmount").value;
  const betAmountDisplay = document.getElementById("betAmountDisplay");
  betAmountDisplay.textContent = `${betAmount} ETH`;
}

// Validate bet
function validateBet() {
  const betAmount = document.getElementById("betAmount").value;
  const placeBetButton = document.getElementById("placeBet");
  const minBet = parseFloat(document.getElementById("minBet").textContent);
  const maxBet = parseFloat(document.getElementById("maxBet").textContent);
  const betAmountFloat = parseFloat(betAmount);

  // Enable button if bet amount is valid and either a number or bet type is selected
  placeBetButton.disabled = !(
    betAmountFloat >= minBet &&
    betAmountFloat <= maxBet &&
    (selectedNumber !== null || selectedBetType !== null)
  );

  // Add validation feedback
  const betAmountInput = document.getElementById("betAmount");
  if (betAmountFloat < minBet) {
    betAmountInput.setCustomValidity(
      `Bet amount must be at least ${minBet} ETH`
    );
  } else if (betAmountFloat > maxBet) {
    betAmountInput.setCustomValidity(`Bet amount cannot exceed ${maxBet} ETH`);
  } else {
    betAmountInput.setCustomValidity("");
  }
}

async function getAccount() {
  const accounts = await provider.send("eth_requestAccounts", []);
  if (accounts.length === 1) {
    return accounts[0];
  } else {
    // Create dropdown dialog
    const dialog = document.createElement("div");
    dialog.style.cssText = `
          position: fixed;
          top: 50%;
          left: 50%;    
          transform: translate(-50%, -50%);
          background: var(--bg-card);
          padding: 20px;
          border-radius: 8px;
          border: 1px solid var(--border-color);
          z-index: 1000;
        `;

    dialog.innerHTML = `
          <h5 style="color: var(--text-primary); margin-bottom: 15px;">Select Account</h5>
          <select class="form-control" style="margin-bottom: 15px;">
            ${accounts
              .map((acc, i) => `<option value="${acc}">${acc}</option>`)
              .join("")}
          </select> 
          <button class="btn btn-primary w-100">Confirm</button>
        `;

    document.body.appendChild(dialog);

    return new Promise((resolve) => {
      dialog.querySelector("button").onclick = async () => {
        let selectedAccount = dialog.querySelector("select").value;
        document.body.removeChild(dialog);
        resolve(selectedAccount);
      };
    });
  }
}

// Connect wallet
async function connectWallet() {
  try {
    if (!window.ethereum) {
      alert("Please install MetaMask!");
      return;
    }

    provider = new ethers.providers.Web3Provider(window.ethereum);

    await window.ethereum.request({
      method: "wallet_requestPermissions",
      params: [
        {
          eth_accounts: {},
        },
      ],
    });

    const account = await getAccount();

    currentWallet = account;

    // Update UI
    document.getElementById("walletAddress").textContent = currentWallet;
    document.getElementById("connectWallet").textContent = "Connected";

    // Initialize contract with signer
    signer = provider.getSigner(currentWallet);
    gameContract = gameContract.connect(signer);

    // Update balance
    await loadGameInfo();
  } catch (error) {
    console.error("Error connecting wallet:", error);
    alert("Error connecting wallet: " + error.message);
  }
}

// Place bet
async function placeBet() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    const betAmount = document.getElementById("betAmount").value;
    const betAmountWei = ethers.utils.parseEther(betAmount);

    // Determine the bet option based on selection
    let betOption;
    if (selectedNumber !== null) {
      // Direct number bet (0-37)
      betOption = selectedNumber === "00" ? 37 : selectedNumber;
    } else {
      // Map bet type to option constant
      const betTypeMap = {
        red: 40, // OPTION_RED
        black: 41, // OPTION_BLACK
        even: 42, // OPTION_EVEN
        odd: 43, // OPTION_ODD
        "1to18": 38, // OPTION_LOW
        "19to36": 39, // OPTION_HIGH
        firstColumn: 44, // OPTION_FIRST_COLUMN
        secondColumn: 45, // OPTION_SECOND_COLUMN
        thirdColumn: 46, // OPTION_THIRD_COLUMN
        firstDozen: 47, // OPTION_FIRST_DOZEN
        secondDozen: 48, // OPTION_SECOND_DOZEN
        thirdDozen: 49, // OPTION_THIRD_DOZEN
      };
      betOption = betTypeMap[selectedBetType];
    }

    // Place bet with the determined option
    const tx = await gameContract.placeBet(betOption, { value: betAmountWei });
    await tx.wait();

    // Update UI
    alert("Bet placed successfully!");
    await loadGameInfo();
  } catch (error) {
    console.error("Error placing bet:", error);
    alert("Error placing bet: " + error.message);
  }
}

// Handle account changes
async function handleAccountsChanged(accounts) {
  if (accounts.length === 0) {
    // Disconnected
    currentWallet = null;
    document.getElementById("walletAddress").textContent = "";
    document.getElementById("connectWallet").textContent = "Connect Wallet";
  } else {
    // Account changed
    currentWallet = accounts[0];
    document.getElementById("walletAddress").textContent = currentWallet;
    await loadGameInfo();
  }
}

// Handle chain changes
function handleChainChanged() {
  window.location.reload();
}

// Update game status display
function updateGameStatus(status) {
  const statusElement = document.getElementById("gameStatus");
  const descriptionElement = document.getElementById("statusDescription");
  const lastUpdatedElement = document.getElementById("lastUpdated");
  const resultStatusElement = document.getElementById("resultStatusText");
  const generateResultButton = document.getElementById("generateResult");
  const validateResultButton = document.getElementById("validateResult");
  const statusInfo = GAME_STATUS[status];

  if (statusInfo) {
    statusElement.textContent = statusInfo.text;
    statusElement.className = `status-badge ${statusInfo.class}`;
    descriptionElement.textContent = statusInfo.description;
    lastUpdatedElement.textContent = new Date().toLocaleTimeString();

    // Update button states based on status
    switch (status) {
      case 0: // Pending Host Deposit
        generateResultButton.disabled = true;
        validateResultButton.disabled = true;
        break;
      case 1: // Accepting Bets
        generateResultButton.disabled = true;
        validateResultButton.disabled = true;
        break;
      case 2: // No More Bets
        generateResultButton.disabled = false;
        validateResultButton.disabled = true;
        break;
      case 3: // Result Generated
        generateResultButton.disabled = true;
        validateResultButton.disabled = false;
        break;
      case 4: // Result Validated
        generateResultButton.disabled = true;
        validateResultButton.disabled = true;
        break;
      case 5: // Game Canceled
        generateResultButton.disabled = true;
        validateResultButton.disabled = true;
        break;
      case 6: // Game Finished
        generateResultButton.disabled = true;
        validateResultButton.disabled = true;
        break;
    }
  } else {
    statusElement.textContent = "Unknown Status";
    statusElement.className = "status-badge status-pending";
    descriptionElement.textContent = "Unable to determine game status";
    lastUpdatedElement.textContent = new Date().toLocaleTimeString();
    generateResultButton.disabled = true;
    validateResultButton.disabled = true;
  }

  // Update betting panel based on status
  const bettingPanel = document
    .querySelector("#placeBet")
    .closest(".card-body");
  const placeBetButton = document.getElementById("placeBet");

  if (status === 1) {
    // STATUS_PENDING_PLAYER_BET
    bettingPanel.style.opacity = "1";
    placeBetButton.disabled = false;
  } else {
    bettingPanel.style.opacity = "0.5";
    placeBetButton.disabled = true;
  }
}

// Validate deposit amount
function validateDeposit() {
  const depositInput = document.getElementById("hostDepositAmountInput");
  const makeDepositButton = document.getElementById("makeDeposit");
  const validationMessage = document.getElementById("depositValidationMessage");
  const depositAmount = parseFloat(depositInput.value);
  const minDeposit = parseFloat(
    document.getElementById("minDepositAmount").textContent
  );

  if (depositAmount <= 0) {
    makeDepositButton.disabled = true;
    validationMessage.textContent = "Please enter a valid deposit amount";
    validationMessage.style.color = "var(--text-secondary)";
  } else if (depositAmount < minDeposit) {
    makeDepositButton.disabled = true;
    validationMessage.textContent = `Deposit amount must be at least ${minDeposit} ETH`;
    validationMessage.style.color = "#dc3545";
  } else {
    makeDepositButton.disabled = false;
    validationMessage.textContent = "Deposit amount is valid";
    validationMessage.style.color = "#198754";
  }
}

// Make deposit
async function makeDeposit() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    const depositAmount = document.getElementById(
      "hostDepositAmountInput"
    ).value;
    const depositAmountWei = ethers.utils.parseEther(depositAmount);

    // Make deposit
    const tx = await gameContract.deposit({ value: depositAmountWei });
    await tx.wait();

    // Update UI
    alert("Deposit made successfully!");
    document.getElementById("hostDepositAmountInput").value = "";
    document.getElementById("depositValidationMessage").textContent = "";
    await loadGameInfo();
  } catch (error) {
    console.error("Error making deposit:", error);
    alert("Error making deposit: " + error.message);
  }
}

// Fetch and update game history
async function updateGameHistory() {
  try {
    const response = await fetch(`/de-game/api/events?address=${contractAddress}`);
    const result = await response.json();

    if (result.success) {
      const gameHistory = document.getElementById("gameHistory");
      gameHistory.innerHTML = ""; // Clear existing history

      // Sort events by block number (newest first)
      const sortedEvents = result.events.sort(
        (a, b) => a.blockNumber - b.blockNumber
      );

      sortedEvents.forEach((event) => {
        const eventElement = createEventElement(event);
        gameHistory.appendChild(eventElement);
      });
    }
  } catch (error) {
    console.error("Error fetching game history:", error);
  }
}

// Helper function to safely format ETH amounts
function formatEthAmount(amount) {
  try {
    if (!amount) return "0 ETH";
    return `${ethers.utils.formatEther(amount)} ETH`;
  } catch (error) {
    console.error("Error formatting amount:", error);
    return "0 ETH";
  }
}

// Helper function to format BigNumber values
function formatBigNumber(value) {
  try {
    if (!value) return "0";
    if (typeof value === "object" && value.hex) {
      return ethers.BigNumber.from(value.hex).toString();
    }
    return value.toString();
  } catch (error) {
    console.error("Error formatting BigNumber:", error);
    return "0";
  }
}

// Create event element for display
function createEventElement(event) {
  const div = document.createElement("div");
  div.className = "list-group-item";

  // Format timestamp if available, otherwise show block number
  const timestamp = event.timestamp
    ? new Date(event.timestamp * 1000).toLocaleString()
    : `Block #${event.blockNumber}`;

  // Format event data based on event type
  let eventContent = "";
  switch (event.event) {
    case "GameCreated":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Game Created</h6>
            <small class="text-muted">Host: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Min Bet: ${formatEthAmount(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Min Deposit: ${formatEthAmount(
              event.args[2]
            )}</small>
            <br>
            <small class="text-muted">Validators: ${
              event.args[3] || "N/A"
            }</small>
            <br>
            <small class="text-muted">Validator Threshold: ${
              event.args[4] || "N/A"
            }</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "DepositPlaced":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Host Deposit Placed</h6>
            <small class="text-muted">Host: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Max Bet: ${formatEthAmount(
              event.args[2]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "DepositRefund":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Deposit Refunded</h6>
            <small class="text-muted">Host: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Reason: ${event.args[2] || "N/A"}</small> 
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "DepositPayout":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Deposit Payout</h6>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args[0]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "BetPlaced":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Bet Placed</h6>
            <small class="text-muted">Player: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Option: ${event.args[1] || "N/A"}</small>
            <br>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args[2]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "BetRefund":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Bet Refunded</h6>
            <small class="text-muted">Player: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Reason: ${event.args[2] || "N/A"}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "BetPayout":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Bet Payout</h6>
            <small class="text-muted">Player: ${event.args[0] || "N/A"}</small>
            <br>
            <small class="text-muted">Option: ${event.args[1] || "N/A"}</small>
            <br>
            <small class="text-muted">Amount: ${formatEthAmount(
              event.args.amount
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "NoMoreBets":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">No More Bets</h6>
            <small class="text-muted">Cut-off Block: ${formatBigNumber(
              event.args[0]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "ResultGenerated":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Result Generated</h6>
            <small class="text-muted">Result: ${formatBigNumber(
              event.args[0]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "ResultAccepted":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Result Accepted</h6>
            <small class="text-muted">Validator: ${
              event.args[0] || "N/A"
            }</small>
            <br>
            <small class="text-muted">Generated: ${formatBigNumber(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Validated: ${formatBigNumber(
              event.args[2]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "ResultRejected":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Result Rejected</h6>
            <small class="text-muted">Validator: ${
              event.args[0] || "N/A"
            }</small>
            <br>
            <small class="text-muted">Generated: ${formatBigNumber(
              event.args[1]
            )}</small>
            <br>
            <small class="text-muted">Validated: ${formatBigNumber(
              event.args[2]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "ResultValidated":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Result Validated</h6>
            <small class="text-muted">Result: ${formatBigNumber(
              event.args[2]
            )}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "GameCanceled":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Game Canceled</h6>
            <small class="text-muted">Reason: ${event.args[0]}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "ValidationLog":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Validation Log</h6>
            <small class="text-muted">Validator: ${event.args[0]}</small>
            <br>
            <small class="text-muted">Step: ${event.args[1]}</small>
            <br>
            <small class="text-muted">Status: ${
              event.args[2] ? "Success" : "Failed"
            }</small>
            <br>
              <small class="text-muted">Message: ${event.args[3]}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    case "GameFinished":
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">Game Finished</h6>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
      break;
    default:
      eventContent = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h6 class="mb-1">${event.event}</h6>
            <small class="text-muted">Block: ${event.blockNumber}</small>
          </div>
          <small class="text-muted">${timestamp}</small>
        </div>
      `;
  }

  div.innerHTML = eventContent;
  return div;
}

// Generate result
async function generateResult() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    // Generate result
    const tx = await gameContract.generateResult();
    await tx.wait();

    // Update UI
    alert("Result generated successfully!");
    await loadGameInfo();
    await updateGameHistory();
  } catch (error) {
    console.error("Error generating result:", error);
    alert("Error generating result: " + error.message);
  }
}

// Accept result
async function acceptResult() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    const tx = await gameContract.acceptResult();
    await tx.wait();

    alert("Result accepted successfully!");
    await loadGameInfo();
    await updateGameHistory();
  } catch (error) {
    console.error("Error accepting result:", error);
    alert("Error accepting result: " + error.message);
  }
}

// Reject result
async function rejectResult() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    const tx = await gameContract.rejectResult();
    await tx.wait();

    alert("Result rejected successfully!");
    await loadGameInfo();
    await updateGameHistory();
  } catch (error) {
    console.error("Error rejecting result:", error);
    alert("Error rejecting result: " + error.message);
  }
}

// Validate result
async function validateResult() {
  try {
    if (!currentWallet) {
      alert("Please connect your wallet first!");
      return;
    }

    const tx = await gameContract.validateResult();
    await tx.wait();

    alert("Result validated successfully!");
    await loadGameInfo();
    await updateGameHistory();
  } catch (error) {
    console.error("Error validating result:", error);
    alert("Error validating result: " + error.message);
  }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  initGame();

  // Update game history every 5 seconds
  setInterval(updateGameHistory, 5000);

  // Initial history load
  updateGameHistory();
});
