
//.H FILE

#ifndef PLAYLISTNODE_H

#define PLAYLISTNODE_H

#include <iostream>

#include <string>

 

class PlaylistNode {

public:

    PlaylistNode();

    PlaylistNode(std::string uniqueID, std::string songName, std::string artistName, int songLength);

 

    std::string GetID() const;

    std::string GetSongName() const;

    std::string GetArtistName() const;

    int GetSongLength() const;

    PlaylistNode* GetNext() const;

 

    void InsertAfter(PlaylistNode* nodePtr);

    void SetNext(PlaylistNode* nodePtr);

    void PrintPlaylistNode() const;

 

private:

    std::string uniqueID;

    std::string songName;

    std::string artistName;

    int songLength;

    PlaylistNode* nextNodePtr;

};  

#endif
