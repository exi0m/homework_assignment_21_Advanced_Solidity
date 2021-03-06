pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale{

    constructor(
        uint rate, 
        address payable wallet, 
        PupperCoin token
        uint goal,
        uint opening_time,
        uint closing_time,
    )
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(opening_time, closing_time)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        public
    {
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);
                
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, goal, now, now + 24 weeks, token);
        token_sale_address = address(token_sale);

        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
