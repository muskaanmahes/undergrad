#include <iostream>
#include "PlaylistNode.h"

using namespace std;
// Function declaration
PlaylistNode* MoveNode(PlaylistNode* head, int currentPos, int newPos);

void PrintMenu(const std::string& playlistTitle) {
    std::cout << playlistTitle << " PLAYLIST MENU" << std::endl;
    std::cout << "a - Add song" << std::endl;
    std::cout << "d - Remove song" << std::endl; 
    std::cout << "c - Change position of song" << std::endl;
    std::cout << "s - Output songs by specific artist" << std::endl;
    std::cout << "t - Output total time of playlist (in seconds)" << std::endl;
    std::cout << "o - Output full playlist" << std::endl;
    std::cout << "q - Quit" << std::endl << endl;
}

PlaylistNode* ExecuteMenu(char choice, const std::string& playlistTitle, PlaylistNode* head) {
    if (choice == 'o') {
        std::cout << playlistTitle << " - OUTPUT FULL PLAYLIST" << std::endl;
        if (!head) {
            std::cout << "Playlist is empty" << std::endl << endl;
        } else {
            int position = 1;
            PlaylistNode* current = head;
            while (current) {
                std::cout << position << "." << std::endl;
                current->PrintPlaylistNode();
                current = current->GetNext();
                position++;
            }
        }
    } else if (choice == 'a') {
        std::cout << "ADD SONG" << std::endl;
        std::string uniqueID, songName, artistName;
        int songLength;
        std::cout << "Enter song's unique ID:" << std::endl;
        std::cin.ignore(); // Ignore the newline character
        std::getline(std::cin, uniqueID);
        std::cout << "Enter song's name:" << std::endl;
        std::getline(std::cin, songName);
        std::cout << "Enter artist's name:" << std::endl;
        std::getline(std::cin, artistName);
        std::cout << "Enter song's length (in seconds):" << std::endl << endl;
        std::cin >> songLength;

        PlaylistNode* newNode = new PlaylistNode(uniqueID, songName, artistName, songLength);
        if (!head) {
            head = newNode;
        } else {
            PlaylistNode* current = head;
            while (current->GetNext()) {
                current = current->GetNext();
            }
            current->SetNext(newNode);
        }
    } else if (choice == 'd') {
        std::cout << "REMOVE SONG" << std::endl;
        std::string uniqueID;
        std::cout << "Enter song's unique ID:" << std::endl;
        std::cin.ignore(); // Ignore the newline character
        std::getline(std::cin, uniqueID);

        PlaylistNode* current = head;
        PlaylistNode* previous = nullptr;

        while (current && current->GetID() != uniqueID) {
            previous = current;
            current = current->GetNext();
        }

        if (current) {
            if (previous) {
                previous->SetNext(current->GetNext());
                delete current;
            } else {
                head = current->GetNext();
                delete current;
            }
            std::cout << "\"" << current->GetSongName() << "\" removed." << std::endl << endl;
        } else {
            std::cout << "Song with ID \"" << uniqueID << "\" not found." << std::endl;
        }
    } else if (choice == 'c') {
        std::cout << "CHANGE POSITION OF SONG" << std::endl;
        int currentPos, newPos;
        std::cout << "Enter current position of the song:" << std::endl;
        std::cin >> currentPos;
        std::cout << "Enter new position of the song:" << std::endl;
        std::cin >> newPos;

        // Ensure positions are valid
        currentPos = std::max(currentPos, 1);
        newPos = std::max(newPos, 1);

        head = MoveNode(head, currentPos, newPos);
    } else if (choice == 's') {
        std::cout << "OUTPUT SONGS BY SPECIFIC ARTIST" << std::endl;
        std::string artistName;
        std::cout << "Enter artist's name:" << std::endl;
        cout << endl;
        std::cin.ignore(); // Ignore the newline character
        std::getline(std::cin, artistName);

        int position = 1;
        PlaylistNode* current = head;

        while (current) {
            if (current->GetArtistName() == artistName) {
                std::cout << position << "." << std::endl;
                current->PrintPlaylistNode();
            }
            current = current->GetNext();
            position++;
        }
    } else if (choice == 't') {
        std::cout << "OUTPUT TOTAL TIME OF PLAYLIST (IN SECONDS)" << std::endl;
        int totalTime = 0;
        PlaylistNode* current = head;

        while (current) {
            totalTime += current->GetSongLength();
            current = current->GetNext();
        }

        std::cout << "Total time: " << totalTime << " seconds" << std::endl << endl;
    }

    return head;
}

// Function definition for MoveNode
PlaylistNode* MoveNode(PlaylistNode* head, int currentPos, int newPos) {
    // ...

    return head;
}

int main() {
    std::cout << "Enter playlist's title:" << std::endl << endl;
    std::string playlistTitle;
    std::getline(std::cin, playlistTitle);

    char choice;
    PlaylistNode* head = nullptr; // Initialize the head of the playlist

    do {
        PrintMenu(playlistTitle);
        std::cout << "Choose an option:" << endl;
        std::cin >> choice;
        head = ExecuteMenu(choice, playlistTitle, head);
    } while (choice != 'q');

    // Cleanup: Delete all nodes in the playlist
    PlaylistNode* current = head;
    while (current) {
        PlaylistNode* next = current->GetNext();
        delete current;
        current = next;
    }

    return 0;
}
