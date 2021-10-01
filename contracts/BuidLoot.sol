pragma solidity ^0.8.0;

//Import some zepplin contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract BuidLoot is ERC721URIStorage {

    //HELPERS
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // WORD LOGIC
    string[] firstWords = ["Buildspace", "Coinbase", "Opensea", "Rarible", "Decentraland", "Lol", "Coin", "Wallet", "Bitcoin" , "Ethereum" , "Chainlink" , "Polygon" , "ERC20", "ERC721"];

    string[] secondWords = ["Hodl", "Build", "ToMoon", "Crpyto", "Yolo", "Ape", "FUD" , "Rugpull" , "Defi" , "POS" , "POW" ];

    string[] thirdWords = ["Amazing", "Mint", "Nft", "Culture", "Art", "Haha", "Nakamoto", "Yahoo" , "Bull" , "Bear" ];
    
    string[] colors = ["red", "#0852B", "black", "yellow", "blue", "green", "purple", "orange", "white", "grey"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);
    //SVG LOGIC
    // string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    // We split the SVG at the part where it asks for the background color.
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    //Functions to randomly pick a word from the array.
    function pickRandomFirstWord(uint tokenId) public view returns (string memory) {
        uint rand  = random(string(abi.encodePacked("FIRST_WORD",Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

      // Same old stuff, pick a random color.
    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    constructor() ERC721("BUIDLOOT", "BUIDLOOT"){
        console.log("This BuidLoot Contract Alive. WOW");
    }

    function createBuidloot() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        string memory combinedWord = string(abi.encodePacked(first, second, third));

            // Add the random color in.
    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "OWN CRYPTO CULTURE ON CHAIN", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

         // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
    
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}