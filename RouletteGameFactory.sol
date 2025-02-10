// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;
import "./RouletteGame.sol";
contract RouletteGameFactory {
    RouletteGame[] private _rouletteGames;
    function createRouletteGame(
        address _host,
        uint256 _minBet,
        address[] memory _validators,
        uint8 _valid_threshold
    ) public {
        RouletteGame rouletteGame = new RouletteGame(
            _host,
            _minBet,
            _validators,
            _valid_threshold
        );
        _rouletteGames.push(rouletteGame);
    }
}
