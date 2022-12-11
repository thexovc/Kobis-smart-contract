// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Kosbis
 */
contract Kosbis {
    uint256 communityCounter;

    struct advert {
        string name;
        string desc;
        string image;
        string link;
        address payable addr;
        uint256 price;
    }

    struct CommunityContent {
        string name;
        uint256 uid;
        address payable admin;
        address [] members;
        uint256 membersNum;
        advert [] advertisement;
        uint256 adPrice;
        uint256 postNum;
    }

    struct Profile {
        address payable addr;
        string name;
        string bio;
        string img;
        address [] followers;
        uint256 followersNum;
        uint256 balance;
        uint256 postNum;
        bool verfied;
        uint256 [] communities;
        uint256 communityNum;
    }

    struct PostContent {
        string name;
        string post;
        uint256 time;
        bool hideIdentity;
        address addr;
        uint256 community;
        fileContent file;
        mapping(address => CommentContent) comment;
    }

    struct fileContent {
        string fileIpfs;
        string fileType;
    }

    struct CommentContent {
        address payable addr;
        string post;
        uint256 time;
        fileContent [] file;
        mapping(address => NestedCommentContent) comment;
    }

    struct NestedCommentContent {
        address payable addr;
        string post;
        uint256 time;
        fileContent [] file;
    }

    mapping(uint256 => CommunityContent) public communityProfile;
    mapping(address => Profile) public User;
    mapping(address => PostContent []) public Post;

    function createUser(
        string memory name,
        string memory bio,
        string memory img,
        uint256 [] memory communities
    ) public {
        User[msg.sender].addr = payable(msg.sender);
        User[msg.sender].name = name;
        User[msg.sender].bio = bio;
        User[msg.sender].img = img;
        User[msg.sender].communities = communities;

        for(uint256 i = 0; i < communities.length; i++){
            communityProfile[communities[i]].membersNum++;
        }
    }

    function createCommunity (
        string memory name       
    ) public {
        communityProfile[communityCounter].name = name;
        communityProfile[communityCounter].uid = communityCounter;
        communityProfile[communityCounter].admin = payable(msg.sender);
    }

    function createPost(
        string memory name,
        string memory post,
        bool hideIdentity,
        uint256 community,
        string memory fileIpfs,
        string memory fileType
    )  public  {
        uint256 myPost = User[msg.sender].postNum;

        fileContent memory newFile;
        newFile.fileIpfs = fileIpfs;
        newFile.fileType = fileType;

        Post[msg.sender][myPost].addr = msg.sender;
        Post[msg.sender][myPost].name = name;
        Post[msg.sender][myPost].post = post;
        Post[msg.sender][myPost].time = block.timestamp;
        Post[msg.sender][myPost].hideIdentity = hideIdentity;
        Post[msg.sender][myPost].community = community;
        Post[msg.sender][myPost].file = newFile;

        communityProfile[community].postNum++;  
        User[msg.sender].postNum++; 
    }

}