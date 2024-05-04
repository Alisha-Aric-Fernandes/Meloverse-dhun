// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicApp {
    struct Song {
        uint256 id;
        address artist;
        string title;
        string contentURI;
        uint256 price; // Price in wei
        uint256 numberOfPurchases;
    }

    mapping(uint256 => Song) public songs;
    uint256 public songCount;

    event SongUploaded(uint256 id, address indexed artist, string title, string contentURI, uint256 price);
    event SongPurchased(uint256 id, address indexed buyer, string title, uint256 price);

    function uploadSong(string memory _title, string memory _contentURI, uint256 _price) external {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_contentURI).length > 0, "Content URI cannot be empty");
        require(_price > 0, "Price must be greater than zero");

        songCount++;
        songs[songCount] = Song(songCount, msg.sender, _title, _contentURI, _price, 0);
        emit SongUploaded(songCount, msg.sender, _title, _contentURI, _price);
    }

    function purchaseSong(uint256 _id) external payable {
        require(_id > 0 && _id <= songCount, "Invalid song ID");
        Song storage song = songs[_id];
        require(msg.value >= song.price, "Insufficient funds");
        
        // Transfer funds to artist
        payable(song.artist).transfer(msg.value);
        
        // Update song purchase count
        song.numberOfPurchases++;
        
        emit SongPurchased(_id, msg.sender, song.title, song.price);
    }
}