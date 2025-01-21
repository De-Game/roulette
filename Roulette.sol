// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.2 <0.9.0;

/**
 * @title Roulette
 * @notice A simplified Roulette smart contract demonstration (not production-ready).
 */
contract Roulette {
    // ----------------------------------
    // Structs & Enums
    // ----------------------------------

    struct Bet {
        address player;
        uint8 number; // 0 to 36
        uint256 amount;
    }

    // ----------------------------------
    // State Variables
    // ----------------------------------

    // Track current bets in this round
    Bet[] public bets;

    // Minimum bet required to play
    uint256 public minBet;

    // Owner of the contract (house)
    address public owner;

    // We store the block number at which we’ll fetch the blockhash
    uint256 public spinBlockNumber;

    // Temporary storage to indicate a spin is "scheduled" but not finalized
    bool public spinInProgress;
    // ----------------------------------
    // Modifiers
    // ----------------------------------

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // ----------------------------------
    // Events
    // ----------------------------------

    event BetPlaced(address indexed player, uint8 number, uint256 amount);
    event SpinScheduled(uint256 indexed spinBlockNumber);
    event SpinResult(uint8 winningNumber);
    event Payout(address indexed player, uint256 amount);
    event HouseProfit(address indexed house, uint256 amount);

    // ----------------------------------
    // Constructor
    // ----------------------------------

    /**
     * @dev Constructor sets the initial owner (house) and minimum bet.
     * @param _minBet The minimum bet size required.
     */
    constructor(uint256 _minBet) {
        owner = msg.sender;
        minBet = _minBet;
    }

    // ----------------------------------
    // Public / External Functions
    // ----------------------------------

    /**
     * @notice Places a bet on a number between 0 and 36.
     * @param number The roulette number on which the user wants to bet (0-36).
     */
    function placeBet(uint8 number) external payable {
        require(number <= 36, "Number must be between 0 and 36");
        require(msg.value >= minBet, "Bet amount is below the minimum bet");

        bets.push(Bet({ 
            player: msg.sender, 
            number: number, 
            amount: msg.value 
        }));

        emit BetPlaced(msg.sender, number, msg.value);
    }

    
    /**
     * @dev 1st step: Schedule the spin. We'll wait 7 blocks, then finalize.
     *
     * - Sets spinBlockNumber = current block + 7.
     * - That means in ~7 blocks from now, `finalizeSpin()` can fetch the blockhash.
     */
    function spinWheel() external onlyOwner {
        require(!spinInProgress, "Spin already in progress");
        require(bets.length > 0, "No bets placed");

        // Schedule a block in the near future
        spinBlockNumber = block.number + 7;
        spinInProgress = true;

        emit SpinScheduled(spinBlockNumber);
    }

    /**
     * @dev 2nd step: Finalize the spin, using blockhash(spinBlockNumber) as our pseudo-random seed.
     *
     * You must wait until AFTER `spinBlockNumber` is mined (i.e., block >= spinBlockNumber).
     * If you wait too long (> 256 blocks), blockhash will return bytes32(0).
     */
    function finalizeSpin() external onlyOwner {
        require(spinInProgress, "No spin in progress");
        require(block.number >= spinBlockNumber, "Not enough blocks have passed");

        // Retrieve the future block's hash (which is now in the past).
        bytes32 futureBlockHash = blockhash(spinBlockNumber);

        // If >256 blocks have passed, blockhash(...) can be 0.
        // Also, if the block isn’t mined yet (which can’t happen if block.number >= spinBlockNumber),
        // the hash might be zero. Usually, you'd handle these edge cases gracefully.
        require(futureBlockHash != bytes32(0), "Blockhash not available or too old");

        // Naive pseudo-randomness
        uint256 randomHash = uint256(
            keccak256(
                abi.encodePacked(
                    futureBlockHash,
                    address(this),
                    bets.length
                )
            )
        );

        uint8 winningNumber = uint8(randomHash % 37);
        emit SpinResult(winningNumber);

        uint256 houseProfit = 0;

        // Distribute winnings
        for (uint256 i = 0; i < bets.length; i++) {
            Bet memory b = bets[i];
            if (b.number == winningNumber) {
                // Standard single-number payout: 36x original bet
                uint256 payoutAmount = b.amount * 36;
                (bool success, ) = b.player.call{ value: payoutAmount }("");
                require(success, "Transfer to winner failed");

                emit Payout(b.player, payoutAmount);
            } else {
                // Losing bets => house profit
                houseProfit += b.amount;
            }
        }

        // Send profits to the owner
        if (houseProfit > 0) {
            (bool housePaid, ) = owner.call{ value: houseProfit }("");
            require(housePaid, "Transfer to house failed");
            emit HouseProfit(owner, houseProfit);
        }

        // Reset for next round
        delete bets;
        spinInProgress = false;
    }

    // ----------------------------------
    // View / Utility Functions
    // ----------------------------------

    /**
     * @notice Returns the total number of bets in the current round.
     */
    function getNumberOfBets() external view returns (uint256) {
        return bets.length;
    }

    /**
     * @notice Returns all current bets. 
     * @dev For large arrays, consider pagination or other indexing to avoid gas limit issues.
     */
    function getCurrentBets() external view returns (Bet[] memory) {
        return bets;
    }

    /**
     * @notice Change the minimum bet (only owner).
     * @param _newMinBet New minimum bet amount.
     */
    function setMinBet(uint256 _newMinBet) external onlyOwner {
        minBet = _newMinBet;
    }
    
    /**
     * @notice Owner can withdraw any leftover balance (in case of stuck funds).
     */
    function withdrawHouseFunds(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Not enough contract balance");
        (bool success, ) = owner.call{ value: _amount }("");
        require(success, "Withdraw failed");
    }

    // Fallback to allow contract to receive ETH without a function call
    receive() external payable {}
}