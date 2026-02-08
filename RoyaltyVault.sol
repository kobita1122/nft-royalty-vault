// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title RoyaltyVault
 * @dev Distributes ETH royalties to multiple stakeholders based on shares.
 */
contract RoyaltyVault {
    event PaymentReleased(address to, uint256 amount);
    event PaymentReceived(address from, uint256 amount);

    uint256 public totalShares;
    uint256 public totalReleased;

    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    address[] public stakeholders;

    constructor(address[] memory _stakeholders, uint256[] memory _shares) {
        require(_stakeholders.length == _shares.length, "Arrays length mismatch");
        require(_stakeholders.length > 0, "No stakeholders provided");

        for (uint256 i = 0; i < _stakeholders.length; i++) {
            address stakeholder = _stakeholders[i];
            uint256 share = _shares[i];

            require(stakeholder != address(0), "Invalid stakeholder address");
            require(share > 0, "Share must be greater than zero");
            require(shares[stakeholder] == 0, "Stakeholder already added");

            stakeholders.push(stakeholder);
            shares[stakeholder] = share;
            totalShares += share;
        }
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    /**
     * @dev Release the share of ETH for a specific stakeholder.
     */
    function release(address payable _account) public {
        require(shares[_account] > 0, "Account has no shares");

        uint256 totalReceived = address(this).balance + totalReleased;
        uint256 payment = (totalReceived * shares[_account]) / totalShares - released[_account];

        require(payment != 0, "Account is not due payment");

        released[_account] += payment;
        totalReleased += payment;

        (bool success, ) = _account.call{value: payment}("");
        require(success, "Transfer failed");

        emit PaymentReleased(_account, payment);
    }
}
