// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProofVault - a blockchain notary for documents
/// @notice Stores the SHA-256 fingerprint of a file with a timestamp. The file itself never goes on-chain.
contract ProofVault {
    struct Record {
        bytes32 hash;
        address owner;
        uint64 timestamp;
        string title;
        bool revoked;
    }

    mapping(bytes32 => Record) private records;
    mapping(address => bytes32[]) private owned;

    event Registered(bytes32 indexed hash, address indexed owner, string title, uint64 timestamp);
    event Revoked(bytes32 indexed hash, address indexed owner);

    /// @notice Register a file fingerprint. Each fingerprint can be registered only once.
    function register(bytes32 hash, string calldata title) external {
        require(hash != bytes32(0), "Empty hash");
        require(records[hash].timestamp == 0, "Already registered");
        require(bytes(title).length <= 100, "Title too long");
        records[hash] = Record(hash, msg.sender, uint64(block.timestamp), title, false);
        owned[msg.sender].push(hash);
        emit Registered(hash, msg.sender, title, uint64(block.timestamp));
    }

    /// @notice Mark your own record as revoked (e.g. a certificate that is no longer valid).
    function revoke(bytes32 hash) external {
        Record storage r = records[hash];
        require(r.owner == msg.sender, "Not the owner");
        require(!r.revoked, "Already revoked");
        r.revoked = true;
        emit Revoked(hash, msg.sender);
    }

    /// @notice Check a fingerprint. Anyone can call this, no wallet needed.
    function verify(bytes32 hash)
        external
        view
        returns (bool exists, address owner, uint64 timestamp, string memory title, bool revoked)
    {
        Record storage r = records[hash];
        return (r.timestamp != 0, r.owner, r.timestamp, r.title, r.revoked);
    }

    /// @notice All records registered by an address.
    function getRecordsOf(address user) external view returns (Record[] memory list) {
        bytes32[] storage ids = owned[user];
        list = new Record[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            list[i] = records[ids[i]];
        }
    }
}
