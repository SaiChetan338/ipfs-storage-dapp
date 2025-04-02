// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FileStorage {
    struct File {
        string ipfsHash;
        address owner;
        mapping(address => bool) sharedWith;
    }

    mapping(string => File) private files;

    event FileUploaded(string indexed ipfsHash, address indexed owner);
    event FileShared(string indexed ipfsHash, address indexed sharedWith);

    function uploadFile(string memory _ipfsHash) external {
        require(bytes(files[_ipfsHash].ipfsHash).length == 0, "File already exists");

        files[_ipfsHash].ipfsHash = _ipfsHash;
        files[_ipfsHash].owner = msg.sender;

        emit FileUploaded(_ipfsHash, msg.sender);
    }

    function shareFile(string memory _ipfsHash, address _user) external {
        require(files[_ipfsHash].owner == msg.sender, "Not the owner");
        files[_ipfsHash].sharedWith[_user] = true;

        emit FileShared(_ipfsHash, _user);
    }

    function canAccess(string memory _ipfsHash, address _user) external view returns (bool) {
        return files[_ipfsHash].owner == _user || files[_ipfsHash].sharedWith[_user];
    }
}
