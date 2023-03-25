// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

struct Campaign {
    uint256 id;
    string title;
    address payable officialOwner;
    uint256 goal;
    uint256 deadline;
    uint256 balance;
    uint256 numberOfDonoros;
}

//deployed: 0xac7e29070a090D6535aD00F8A37798e0E886d308

contract CharityCampaigns {
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256))
        public userDonationPerCampaign;

    uint256 public indexOfCampaign;

    address public owner;

    event StartCampaign(
        uint256 id,
        string title,
        uint256 deadline,
        uint256 goal
    );
    event Donate(uint256 id, uint256 amount, address user);
    event FundsClaimed(uint256 id, address officialOwner, uint256 amount);
    event WithdrawDonation(uint256 id, address user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");

        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function startCampaign(
        string memory _title,
        address payable _official,
        uint256 _goal,
        uint256 _deadline
    ) public onlyOwner {
        require(
            _deadline > block.timestamp,
            "Deadline must be a moment in the future"
        );

        campaigns[indexOfCampaign] = Campaign({
            id: indexOfCampaign,
            title: _title,
            officialOwner: _official,
            goal: _goal,
            deadline: _deadline,
            balance: 0,
            numberOfDonoros: 0
        });

        indexOfCampaign++;

        emit StartCampaign(indexOfCampaign - 1, _title, _deadline, _goal);
    }

    function sendFunds(uint256 _idOfCampaign) public payable {
        Campaign storage campaign = campaigns[_idOfCampaign];

        require(msg.value > 0, "Amount must be a positive value");
        require(campaign.deadline >= block.timestamp, "Campign ends");

        campaign.balance += msg.value;
        campaign.numberOfDonoros++;

        userDonationPerCampaign[_idOfCampaign][msg.sender] += msg.value;

        (bool sent, ) = address(this).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        emit Donate(_idOfCampaign, msg.value, msg.sender);
    }

    //write a receive function
    receive() external payable {}

    //write a function to allow officialOwner to claim funds
    function claimFunds(uint256 _idOfCampaign) public {
        Campaign storage campaign = campaigns[_idOfCampaign];

        require(msg.sender == campaign.officialOwner, "Not the official owner");

        require(
            campaign.balance >= campaign.goal,
            "The goal was not achieved."
        );

        require(campaign.deadline < block.timestamp, "Capaign is not finished");

        (bool sent, ) = msg.sender.call{value: campaign.balance}("");
        require(sent, "Failed to send Ether");

        uint256 balance = campaign.balance;

        delete campaigns[_idOfCampaign];

        emit FundsClaimed(_idOfCampaign, msg.sender, balance);
    }

    //write a function to allow users to withdraw their donation
    function withdrawDonation(uint256 _idOfCampaign) public {
        Campaign storage campaign = campaigns[_idOfCampaign];

        require(
            campaign.deadline > block.timestamp,
            "Campaign is not finished"
        );

        require(campaign.goal > campaign.balance, "The goal is not achieved");

        uint256 donation = userDonationPerCampaign[_idOfCampaign][msg.sender];

        (bool sent, ) = msg.sender.call{value: donation}("");
        require(sent, "Failed to send Ether");

        emit WithdrawDonation(_idOfCampaign, msg.sender, donation);
    }

    //write a function to return the balance of the contract
    function getBalanceOfContract() public view returns (uint256) {
        return address(this).balance;
    }

    //write a getter for campaign
    function getChampaign(
        uint256 _idOfCampaign
    ) public view returns (Campaign memory) {
        return campaigns[_idOfCampaign];
    }

    //write a getter function for use donation
    function getUserDonationPerCampaign(
        uint256 _idOfCampaign,
        address _user
    ) public view returns (uint256) {
        return userDonationPerCampaign[_idOfCampaign][_user];
    }
}
