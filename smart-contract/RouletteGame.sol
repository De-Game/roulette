// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract RouletteGame {
    // * ----------------------------------
    // * Constants
    // *----------------------------------

    // * the random result generated ranges from 0 to 37 (result of "00" is represented as 37);
    uint8 private constant RESULT_COUNT = 38;

    // * ----------------------------------
    // * Bet Options Constants
    // *----------------------------------

    // * straight up bet
    uint8 private constant OPTION_STRAIGHT_UP_ZERO = 0;
    uint8 private constant OPTION_STRAIGHT_UP_ONE = 1;
    uint8 private constant OPTION_STRAIGHT_UP_TWO = 2;
    uint8 private constant OPTION_STRAIGHT_UP_THREE = 3;
    uint8 private constant OPTION_STRAIGHT_UP_FOUR = 4;
    uint8 private constant OPTION_STRAIGHT_UP_FIVE = 5;
    uint8 private constant OPTION_STRAIGHT_UP_SIX = 6;
    uint8 private constant OPTION_STRAIGHT_UP_SEVEN = 7;
    uint8 private constant OPTION_STRAIGHT_UP_EIGHT = 8;
    uint8 private constant OPTION_STRAIGHT_UP_NINE = 9;
    uint8 private constant OPTION_STRAIGHT_UP_TEN = 10;
    uint8 private constant OPTION_STRAIGHT_UP_ELEVEN = 11;
    uint8 private constant OPTION_STRAIGHT_UP_TWELVE = 12;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTEEN = 13;
    uint8 private constant OPTION_STRAIGHT_UP_FOURTEEN = 14;
    uint8 private constant OPTION_STRAIGHT_UP_FIFTEEN = 15;
    uint8 private constant OPTION_STRAIGHT_UP_SIXTEEN = 16;
    uint8 private constant OPTION_STRAIGHT_UP_SEVENTEEN = 17;
    uint8 private constant OPTION_STRAIGHT_UP_EIGHTEEN = 18;
    uint8 private constant OPTION_STRAIGHT_UP_NINETEEN = 19;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY = 20;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_ONE = 21;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_TWO = 22;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_THREE = 23;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_FOUR = 24;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_FIVE = 25;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_SIX = 26;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_SEVEN = 27;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_EIGHT = 28;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_NINE = 29;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY = 30;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_ONE = 31;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_TWO = 32;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_THREE = 33;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_FOUR = 34;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_FIVE = 35;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_SIX = 36;
    uint8 private constant OPTION_STRAIGHT_UP_ZERO_ZERO = 37;

    // * low bet
    uint8 private constant OPTION_LOW = 38;

    function isInLowSet(uint8 number) public pure returns (bool) {
        return number >= 1 && number <= 18;
    }

    // * high bet
    uint8 private constant OPTION_HIGH = 39;
    function isInHighSet(uint8 number) public pure returns (bool) {
        return number >= 19 && number <= 36;
    }

    // * red bet
    uint8 private constant OPTION_RED = 40;
    uint8[18] private OPTION_RED_SET = [
        1,
        3,
        5,
        7,
        9,
        12,
        14,
        16,
        18,
        19,
        21,
        23,
        25,
        27,
        30,
        32,
        34,
        36
    ];
    function isInRedSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_RED_SET.length; i++) {
            if (OPTION_RED_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * black bet
    uint8 private constant OPTION_BLACK = 41;
    uint8[18] private OPTION_BLACK_SET = [
        2,
        4,
        6,
        8,
        10,
        11,
        13,
        15,
        17,
        20,
        22,
        24,
        26,
        28,
        29,
        31,
        33,
        35
    ];
    function isInBlackSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_BLACK_SET.length; i++) {
            if (OPTION_BLACK_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * even bet
    uint8 private constant OPTION_EVEN = 42;

    function isInEvenSet(uint8 number) public pure returns (bool) {
        // Check if number is even and between 2-36
        return number > 0 && number < 37 && number % 2 == 0;
    }

    // * odd bet
    uint8 private constant OPTION_ODD = 43;
    function isInOddSet(uint8 number) public pure returns (bool) {
        // Check if number is odd and between 1-35
        return number > 0 && number < 37 && number % 2 != 0;
    }

    // * first column bet
    uint8 private constant OPTION_FIRST_COLUMN = 44;
    uint8[12] private OPTION_FIRST_COLUMN_SET = [
        1,
        4,
        7,
        10,
        13,
        16,
        19,
        22,
        25,
        28,
        31,
        34
    ];
    function isInFirstColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_FIRST_COLUMN_SET.length; i++) {
            if (OPTION_FIRST_COLUMN_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * second column bet
    uint8 private constant OPTION_SECOND_COLUMN = 45;
    uint8[12] private OPTION_SECOND_COLUMN_SET = [
        2,
        5,
        8,
        11,
        14,
        17,
        20,
        23,
        26,
        29,
        32,
        35
    ];
    function isInSecondColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_SECOND_COLUMN_SET.length; i++) {
            if (OPTION_SECOND_COLUMN_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * third column bet
    uint8 private constant OPTION_THIRD_COLUMN = 46;
    uint8[12] private OPTION_THIRD_COLUMN_SET = [
        3,
        6,
        9,
        12,
        15,
        18,
        21,
        24,
        27,
        30,
        33,
        36
    ];
    function isInThirdColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_THIRD_COLUMN_SET.length; i++) {
            if (OPTION_THIRD_COLUMN_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * first dozen bet
    uint8 private constant OPTION_FIRST_DOZEN = 47;
    uint8[12] private OPTION_FIRST_DOZEN_SET = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12
    ];
    function isInFirstDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_FIRST_DOZEN_SET.length; i++) {
            if (OPTION_FIRST_DOZEN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false;
    }

    // * second dozen bet
    uint8 private constant OPTION_SECOND_DOZEN = 48;
    uint8[12] private OPTION_SECOND_DOZEN_SET = [
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24
    ];
    function isInSecondDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_SECOND_DOZEN_SET.length; i++) {
            if (OPTION_SECOND_DOZEN_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * third dozen bet
    uint8 private constant OPTION_THIRD_DOZEN = 49;
    uint8[12] private OPTION_THIRD_DOZEN_SET = [
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36
    ];
    function isInThirdDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_THIRD_DOZEN_SET.length; i++) {
            if (OPTION_THIRD_DOZEN_SET[i] == number) {
                return true;
            }
        }
        return false;
    }

    // * ----------------------------------
    // * Transaction Constants
    // *----------------------------------

    // * maximum payout ratio
    uint256 private constant PAYOUT_RATIO_MAX = 36;

    // * payout ratio for straight up bet
    uint256 private constant PAYOUT_RATIO_STRAIGHT_UP = 36;

    // * payout ratio for low or high bet
    uint256 private constant PAYOUT_RATIO_LOW_OR_HIGH = 2;

    // * payout ratio for red or black bet
    uint256 private constant PAYOUT_RATIO_RED_OR_BLACK = 2;

    // * payout ratio for even or odd bet
    uint256 private constant PAYOUT_RATIO_EVEN_OR_ODD = 2;

    // * payout ratio for columns bet
    uint256 private constant PAYOUT_RATIO_COLUMNS = 3;

    // * payout ratio for dozen bet
    uint256 private constant PAYOUT_RATIO_DOZEN = 3;

    // * ----------------------------------
    // * Status Constants
    // *----------------------------------

    uint8 private constant STATUS_PENDING_HOST_DEPOSIT = 0;
    uint8 private constant STATUS_PENDING_PLAYER_BET = 1;
    uint8 private constant STATUS_NO_MORE_BETS = 2;
    uint8 private constant STATUS_RESULT_GENERATED = 3;
    uint8 private constant STATUS_RESULT_VALIDATED = 4;
    uint8 private constant STATUS_CANCELED = 5;
    uint8 private constant STATUS_GAME_FINISHED = 6;

    // * offset to make the result immutable
    uint8 private constant BLOCK_NUMBER_OFFSET = 12;

    // * ----------------------------------
    // * Events
    // *----------------------------------
    event GameCreated(
        address indexed host,
        uint256 minBet,
        uint256 minDeposit,
        address[] validators,
        uint8 validatorThreshold
    );
    event DepositPlaced(address indexed host, uint256 amount, uint256 maxBet);
    event DepositRefund(address indexed host, uint256 amount, string reason);
    event DepositPayout(address indexed host, uint256 amount);

    event BetPlaced(address indexed player, uint8 option, uint256 amount);
    event BetRefund(address indexed player, uint256 amount, string reason);
    event BetPayout(address indexed player, uint8 option, uint256 amount);

    event NoMoreBets(uint256 cutOffBlockNumber);
    event ResultGenerated(uint8 generatedResult);

    event ResultAccepted(
        address indexed validator,
        uint8 generatedResult,
        uint8 validatedResult
    );
    event ResultRejected(
        address indexed validator,
        uint8 generatedResult,
        uint8 validatedResult
    );
    event ResultRejected_MismatchPayout(
        address indexed validator,
        string message,
        uint256 validatedResult
    );
    event EmptyResultRejected(
        address indexed validator,
        string message,
        uint256 validatedResult
    );

    event ResultValidated(uint8 validatedResult);

    event GameCanceled(string reason);

    // New event to prove step-by-step hashing
    event ValidationLog(
        address indexed validator,
        uint8 stepIndex,
        bool isSuccess,
        string message
    );

    event GameFinished();

    // * ----------------------------------
    // * Struct
    // *----------------------------------

    // * struct for bet
    struct Bet {
        address player;
        uint8 option; // * options: range from 0 to 49
        uint256 amount;
    }

    // * ----------------------------------
    // * Variables
    // *----------------------------------
    address public owner;
    uint8 public status;
    uint256 public minDeposit;
    uint256 public minBet;
    uint256 public maxBet;
    uint256 public hostDeposit;
    uint256 public cutOffBlockNumber;
    uint8 public result;
    uint8 public validatorThreshold;
    address public host;
    Bet[] public bets;
    address[] public validators;
    address[] public approvedValidators;
    address[] public rejectedValidators;

    // * ----------------------------------
    // * Constructor
    // *----------------------------------

    constructor(
        address _owner,
        address _host,
        uint256 _minBet,
        uint256 _minDeposit,
        address[] memory _validators,
        uint8 _validatorThreshold
    ) {
        require(
            _validatorThreshold <= _validators.length,
            "Validator threshold cannot be greater than the number of validators."
        );
        host = _host;
        minBet = _minBet;
        minDeposit = _minDeposit;
        validators = _validators;
        validatorThreshold = _validatorThreshold;
        status = STATUS_PENDING_HOST_DEPOSIT;
        hostDeposit = 0;
        owner = _owner;
        emit GameCreated(
            _host,
            _minBet,
            _minDeposit,
            _validators,
            _validatorThreshold
        );
    }
    // * ----------------------------------
    // * Private Functions (Type Conversion)
    // *----------------------------------

    // * function to convert uint256 to string
    function _uint256ToString(uint256 _i) private pure returns (string memory) {
        if (_i == 0) {
            return "0"; // Ensure zero is handled correctly
        }

        uint256 j = _i;
        uint256 length = 0;

        // Calculate number of digits in _i
        while (j != 0) {
            length++;
            j /= 10;
        }

        // Create a bytes array of correct size
        bytes memory bstr = new bytes(length);

        uint256 k = length; // Initialize k with length

        j = _i;
        while (j != 0) {
            k--; // Move index before assignment to avoid underflow
            bstr[k] = bytes1(uint8(48 + (j % 10))); // Convert last digit to ASCII
            j /= 10;
        }

        return string(bstr);
    }

    // * function to convert bytes32 to hex string
    function _bytes32ToHexString(
        bytes32 data
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(66); // "0x" + 64 hex chars
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 32; i++) {
            // each byte splits into two hex characters
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }

    // * function to convert bytes to hex string
    function _bytesToHexString(
        bytes memory data
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(data.length * 2 + 2); // "0x" + 2 chars per byte
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < data.length; i++) {
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
    /**
     * @dev Convert a single address to a 0x-prefixed hex string.
     */
    function _addressToString(
        address _addr
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes20 data = bytes20(_addr);
        bytes memory str = new bytes(42); // "0x" + 40 hex chars
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }

    /**
     * @dev Convert an array of addresses into a bracketed list of hex strings.
     *      Example: "[0xAb84..., 0x4B20...]"
     */
    function _addressesToString(
        address[] memory _addrs
    ) private pure returns (string memory) {
        if (_addrs.length == 0) {
            return "[]";
        }

        bytes memory add_result = "[";

        for (uint256 i = 0; i < _addrs.length; i++) {
            add_result = abi.encodePacked(
                add_result,
                _addressToString(_addrs[i])
            );
            if (i < _addrs.length - 1) {
                add_result = abi.encodePacked(add_result, ", ");
            }
        }
        add_result = abi.encodePacked(add_result, "]");
        return string(add_result);
    }

    // * ----------------------------------
    // * Private Functions (Game Logic)
    // *----------------------------------

    // * function to refund all transactions
    function refundAllTransactions(string memory reason) private {
        // * refund all bets
        for (uint256 i = 0; i < bets.length; i++) {
            payable(bets[i].player).transfer(bets[i].amount);
            emit BetRefund(bets[i].player, bets[i].amount, reason);
        }
        // * refund the host deposit
        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > 0) {
            payable(host).transfer(remainingBalance);
            emit DepositRefund(host, remainingBalance, reason);
        }
        status = STATUS_CANCELED;
        emit GameCanceled(reason);
    }

    // * function to check if the caller is a validator
    function isAssignableValidator(
        address _caller
    ) private view returns (bool) {
        bool isValidator = false;
        for (uint256 i = 0; i < validators.length; i++) {
            if (validators[i] == _caller) {
                isValidator = true;
                break;
            }
        }
        // * if the caller is not a validator, return false
        if (!isValidator) {
            return false;
        }
        // * if the caller is already in the approved validators list, return false
        for (uint256 i = 0; i < approvedValidators.length; i++) {
            if (approvedValidators[i] == _caller) {
                return false;
            }
        }
        // * if the caller is already in the rejected validators list, return false
        for (uint256 i = 0; i < rejectedValidators.length; i++) {
            if (rejectedValidators[i] == _caller) {
                return false;
            }
        }
        return true;
    }

// Function to verify payout to players plus host return exactly equals all input funds
function verifyPayoutCoverage(uint256 totalPayout, uint256 hostReturn) public view returns (bool) {
    uint256 totalInput = hostDeposit + getTotalBetsAmount();
    return (totalPayout + hostReturn == totalInput);
}

    // Helper function to get payout multiplier based on bet option (need high ratio on top)
    function getPayoutMultiplier(uint8 option) private pure returns (uint256) {
        if (option <= OPTION_STRAIGHT_UP_ZERO_ZERO) return PAYOUT_RATIO_STRAIGHT_UP;
        if (
            option == OPTION_FIRST_COLUMN ||
            option == OPTION_SECOND_COLUMN ||
            option == OPTION_THIRD_COLUMN 
        ) return PAYOUT_RATIO_COLUMNS;
        if (
            option == OPTION_FIRST_DOZEN ||
            option == OPTION_SECOND_DOZEN ||
            option == OPTION_THIRD_DOZEN
        ) return PAYOUT_RATIO_DOZEN;
        if (
            option == OPTION_LOW ||
            option == OPTION_HIGH 
        ) return PAYOUT_RATIO_LOW_OR_HIGH;
        if (
            option == OPTION_RED ||
            option == OPTION_BLACK 
        ) return PAYOUT_RATIO_RED_OR_BLACK;
        if (
            option == OPTION_EVEN ||
            option == OPTION_ODD
        ) return PAYOUT_RATIO_EVEN_OR_ODD;
        

        revert("Invalid betting option.");
    }

    // Integrated validation and payout calculation in validateResult
    function validateResult() public {
        require(
            status == STATUS_RESULT_GENERATED,
            "Result can not be validated in current status."
        );

        require(
            isAssignableValidator(msg.sender),
            "Only validators can validate the result."
        );

        uint256 usedBlockNumber = cutOffBlockNumber + 1;
        bytes32 randomBlockHash = blockhash(usedBlockNumber);

        if (randomBlockHash == bytes32(0)) {
            emit ValidationLog(msg.sender, 1, false, "Block hash is not available.");
            refundAllTransactions("Block hash is not available.");
            return;
        }

        bytes memory packedData = abi.encodePacked(host);
        for (uint256 j = 0; j < bets.length; j++) {
            packedData = abi.encodePacked(packedData, bets[j].player);
        }

        bytes32 randomHash = keccak256(abi.encodePacked(randomBlockHash, packedData));
        uint256 randomNumber = uint256(randomHash);
        uint8 recomputedResult = uint8(randomNumber % RESULT_COUNT);

        if (recomputedResult != result) {
            rejectedValidators.push(msg.sender);
            emit ResultRejected(msg.sender, result, recomputedResult);
            if (rejectedValidators.length >= validatorThreshold) {
                refundAllTransactions("Majority of validators rejected the result.");
            }
        } else if (recomputedResult == result) {
                uint256 totalPayout = 0;
                uint256[] memory payouts = new uint256[](bets.length);

                for (uint256 i = 0; i < bets.length; i++) {
                    uint8 option = bets[i].option;
                    uint256 amount = bets[i].amount;

                    if (
                        (option <= OPTION_STRAIGHT_UP_ZERO_ZERO && option == result) ||
                        (option == OPTION_LOW && isInLowSet(result)) ||
                        (option == OPTION_HIGH && isInHighSet(result)) ||
                        (option == OPTION_RED && isInRedSet(result)) ||
                        (option == OPTION_BLACK && isInBlackSet(result)) ||
                        (option == OPTION_EVEN && isInEvenSet(result)) ||
                        (option == OPTION_ODD && isInOddSet(result)) ||
                        (option == OPTION_FIRST_COLUMN && isInFirstColumnSet(result)) ||
                        (option == OPTION_SECOND_COLUMN && isInSecondColumnSet(result)) ||
                        (option == OPTION_THIRD_COLUMN && isInThirdColumnSet(result)) ||
                        (option == OPTION_FIRST_DOZEN && isInFirstDozenSet(result)) ||
                        (option == OPTION_SECOND_DOZEN && isInSecondDozenSet(result)) ||
                        (option == OPTION_THIRD_DOZEN && isInThirdDozenSet(result))
                    ) {
                        uint256 payout = amount * getPayoutMultiplier(option);
                        totalPayout += payout;
                        payouts[i] = payout;
                    }
                }

            uint256 contractBalance = address(this).balance;

            if(verifyPayoutCoverage(totalPayout, contractBalance - totalPayout)){
                approvedValidators.push(msg.sender);
                emit ResultAccepted(msg.sender, result, recomputedResult);
            }else{
                rejectedValidators.push(msg.sender);
                emit ResultRejected_MismatchPayout(msg.sender, "Payout + host return must exactly match deposited & bet fail", totalPayout);
                if (rejectedValidators.length >= validatorThreshold) {
                    refundAllTransactions("Majority of validators rejected the result.");
                }
            }

            if (approvedValidators.length >= validatorThreshold) {
                emit ResultValidated(result);
                status = STATUS_RESULT_VALIDATED;

                settleBet(payouts);
            }
        }
    }

    // Optimized settleBet function with single loop and pre-validation moved to validateResult
function settleBet(uint256[] memory payouts) private {
    for (uint256 i = 0; i < bets.length; i++) {
        if (payouts[i] > 0) {
            payable(bets[i].player).transfer(payouts[i]);
            emit BetPayout(bets[i].player, bets[i].option, payouts[i]);
        }
    }

    uint256 hostBalance = address(this).balance;
    if (hostBalance > 0) {
        payable(host).transfer(hostBalance);
        emit DepositPayout(host, hostBalance);
    }

    status = STATUS_GAME_FINISHED;
    emit GameFinished();
}


    // * ----------------------------------
    // * Public Functions
    // *----------------------------------
    function getStatus() public view returns (uint8) {
        return status;
    }

    function getBetsCount() public view returns (uint256) {
        return bets.length;
    }

    function getTotalBetsAmount() public view returns (uint256) {
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < bets.length; i++) {
            totalAmount += bets[i].amount;
        }
        return totalAmount;
    }

    function deposit() public payable {
        require(
            status == STATUS_PENDING_HOST_DEPOSIT,
            "Deposit can not be placed in current status."
        );
        require(msg.sender == host, "Only host can deposit.");

        require(msg.value > 0, "Deposit amount cannot be zero.");
        require(
            msg.value >= minDeposit,
            "Deposit amount is below the minimum deposit."
        );
        // * calculate the maximum accepted (commitable) bet amount based on the deposit amount
        uint256 calMaxBet = (msg.value - (msg.value % PAYOUT_RATIO_MAX)) /
            PAYOUT_RATIO_MAX;
        require(
            calMaxBet >= minBet,
            "Deposit amount can not cover the minimum bet."
        );
        hostDeposit = msg.value;
        maxBet = calMaxBet;
        status = STATUS_PENDING_PLAYER_BET;
        emit DepositPlaced(msg.sender, msg.value, maxBet);
    }

    function withdraw() public {
        require(
            status == STATUS_PENDING_PLAYER_BET,
            "Withdraw can not be called in current status."
        );
        require(msg.sender == host, "Only host can withdraw.");
        refundAllTransactions("Withdrawal requested by host.");
        return;
    }

    function placeBet(uint8 option) public payable {
        require(
            status == STATUS_PENDING_PLAYER_BET,
            "Bet can not be placed in current status."
        );
        require(option <= 49, "Option must be between 0 and 49");
        require(
            msg.value >= minBet,
            "Bet amount cannot be less than the minimum bet amount."
        );
        require(
            msg.value <= maxBet,
            "Bet amount cannot exceed the maximum bet amount."
        );
        Bet memory playerBet = Bet({
            player: msg.sender,
            option: option,
            amount: msg.value
        });
        bets.push(playerBet);
        emit BetPlaced(msg.sender, option, msg.value);

        // * assume player versus host in 1-to-1, the bet cut off once any player placed a bet
        return noMoreBets();
    }

    function noMoreBets() public {
        require(
            status == STATUS_PENDING_PLAYER_BET,
            "Bet cut off can not be placed in current status."
        );

        // * assume player versus host in 1-to-1, the bet cut off once any player placed a bet
        //// require(msg.sender == host, "Only host can call no more bets");

        status = STATUS_NO_MORE_BETS;
        // * set the cut off block number to the current block number
        cutOffBlockNumber = block.number;
        emit NoMoreBets(cutOffBlockNumber);
    }

    // * wait at least 12 blocks before calling this function
    function generateResult() public {
        require(
            status == STATUS_NO_MORE_BETS,
            "Result cannot be generated in current status."
        );
        // * ensure the block number is reached for randomness
        require(
            block.number >= cutOffBlockNumber + BLOCK_NUMBER_OFFSET + 1,
            "Result cannot be generated before the required block number is reached."
        );
        //Just Operator allow to generate result
        require(msg.sender == owner, "Only operator can generate result.");

        // * get the block hash of the earlier block
        uint256 usedBlockNumber = cutOffBlockNumber + 1;
        bytes32 randomBlockHash = blockhash(usedBlockNumber);
        if (randomBlockHash == bytes32(0)) {
            refundAllTransactions("Block hash is not available.");
            return;
        }

        // * add salt to the random hash
        // * add host address as part of the salt
        bytes memory packedData = abi.encodePacked(host);
        // * add player addresses as part of the salt
        for (uint256 i = 0; i < bets.length; i++) {
            packedData = abi.encodePacked(packedData, bets[i].player);
        }

        // * generate the random hash
        bytes32 randomHash = keccak256(
            abi.encodePacked(randomBlockHash, packedData)
        );

        // * naive pseudo-randomness based on the blockhash
        uint256 randomNumber = uint256(randomHash);
        result = uint8(randomNumber % RESULT_COUNT); // * create a random number between 0 and 37 (38 numbers in total).
        status = STATUS_RESULT_GENERATED;
        emit ResultGenerated(result);
    }

    function getApprovedValidators() public view returns (address[] memory) {
        return approvedValidators;
    }

    function getRejectedValidators() public view returns (address[] memory) {
        return rejectedValidators;
    }
  
}
