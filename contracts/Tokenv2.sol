// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Tokenv2 is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, PausableUpgradeable, AccessControlUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant ACCESS_CONTROL_ADMIN = keccak256("ACCESS_CONTROL_ADMIN");
    bytes32 public constant BLACKLISTER_ROLE = keccak256("BLACKLISTER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("Token", "Token");
        __ERC20Burnable_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC20Permit_init("Token");
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, 1000000000 * 10 ** decimals());
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
        _grantRole(ACCESS_CONTROL_ADMIN, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}
    function version() pure public returns (string memory) {
        return "v2";
    }
    function grant_BLACKLISTER_ROLE(address _Blacklister_address) public onlyRole(ACCESS_CONTROL_ADMIN){
        _grantRole(BLACKLISTER_ROLE, _Blacklister_address);
    }
    mapping (address=>bool) blackListed;
    address[] public blackList;
    function blacklist_address(address _address) public onlyRole(BLACKLISTER_ROLE) checkBlacklist(_address){
        blackListed[_address]=true;
        blackList.push(_address);
    }
    function remove_blacklist(address _address) public onlyRole(BLACKLISTER_ROLE) checkBlacklist(_address){
        blackListed[_address]=false;
    }
    modifier checkBlacklist(address _address){
        require(!blackListed[_address],"address Blacklisted");
        _;
    }
    function user_check_blacklisted() public view checkBlacklist(_msgSender()) returns(string memory){
        return "Hello user, you are clear!";
    }
}


