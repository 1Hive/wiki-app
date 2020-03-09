pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";


contract Wiki is AragonApp {

    /// Events
    event Create(address indexed entity, uint256 id, bytes content);
    event Edit(address indexed entity, uint256 id, bytes content);
    event Delete(address indexed entity, uint256 id);

    /// State
    uint256 public id = 0;

    /// ACL
    bytes32 constant public CREATE_PAGE_ROLE = keccak256("CREATE_PAGE_ROLE");
    bytes32 constant public EDIT_PAGE_ROLE = keccak256("EDIT_PAGE_ROLE");
    bytes32 constant public DELETE_PAGE_ROLE = keccak256("DELETE_PAGE_ROLE");

    function initialize() public onlyInit {
        initialized();
    }

    /**
     * @notice Create new page
     * @param _content IPFS hash of the new page
     */
    function createPage(bytes _content) external auth(CREATE_PAGE_ROLE) {
        emit Create(msg.sender, id++, _content);
    }

    /**
     * @notice Edit page #`_id`
     * @param _id Page id
     * @param _content IPFS hash of new content
     */
    function editPage(uint _id, bytes _content) external auth(EDIT_PAGE_ROLE) {
        emit Edit(msg.sender, _id, _content);
    }

    /**
     * @notice Delete page #`_id`
     * @param _id Page id
     */
    function deletePage(uint _id) external auth(DELETE_PAGE_ROLE) {
        emit Delete(msg.sender, _id);
    }
}
