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
        address author;
        uint256 community;
        fileContent file;
        uint256 [] comments;
    }

    struct fileContent {
        string fileIpfs;
        string fileType;
    }

    struct CommentContent {
        address payable author;
        uint256 comId;
        uint256 postId;
        string post;
        uint256 time;
        fileContent file;
        // CommentContent[] comments;
    }

    struct NestedCommentContent {
        address payable addr;
        string post;
        uint256 time;
        fileContent [] file;
    }

    mapping(uint256 => CommunityContent) public communityProfile;
    mapping(address => Profile) public User;
    mapping(uint256 => PostContent []) public Post;
    mapping(address => CommentContent []) public Comment;

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
      
        fileContent memory newFile;
        newFile.fileIpfs = fileIpfs;
        newFile.fileType = fileType;

        PostContent memory newPost;

        newPost.author = msg.sender;
        newPost.name = name;
        newPost.post = post;
        newPost.time = block.timestamp;
        newPost.hideIdentity = hideIdentity;
        newPost.community = community;
        newPost.file = newFile;

        Post[community].push(newPost);

        communityProfile[community].postNum++;  
        User[msg.sender].postNum++; 
    }

    function createComment(
        uint256 comId,
        uint256 postId,
        string memory text,
        string memory fileIpfs,
        string memory fileType
    )public {
        fileContent memory newFile;
        newFile.fileIpfs = fileIpfs;
        newFile.fileType = fileType;

        CommentContent memory newComment;

        newComment.author = payable(msg.sender);
        newComment.comId = comId;
        newComment.postId = postId; 
        newComment.post = text; 
        newComment.time = block.timestamp;
        newComment.file = newFile;

        Comment[msg.sender].push(newComment);


    }

}