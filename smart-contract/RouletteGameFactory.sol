// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
import "./RouletteGame.sol";

contract RouletteGameFactory {
    event GameCreated(address indexed contractAddress);

    mapping(uint256 => address) public gameAddresses;
    uint256 public count;

    constructor() {
        count = 0;
    }

    function create(
        address _host,
        uint256 _minBet,
        uint256 _minDeposit,
        address[] memory _validators,
        uint8 _validThreshold
    ) public {
        RouletteGame game = new RouletteGame(
            msg.sender,
            _host,
            _minBet,
            _minDeposit,
            _validators,
            _validThreshold
        );

        gameAddresses[count] = address(game);
        count++;

        emit GameCreated(address(game));
        return;
    }

    // Function to get all deployed games
    function getAllGames() external view returns (address[] memory) {
        address[] memory allGames = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            allGames[i] = gameAddresses[i];
        }
        return allGames;
    }

    // Function to get a specific game by index
    function getGameByIndex(uint256 _index) external view returns (address) {
        return gameAddresses[_index];
    }
}
