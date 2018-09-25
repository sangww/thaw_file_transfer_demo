#pragma once

#include "ofMain.h"
#include "thawAppInterface.h"
#include "thawAppManager.h"

class navigate3dApp : public thawAppInterface{
    
    public:
        void setup();
        void update();
        void draw();
        
        void keyPressed(int key);
        void keyReleased(int key);
        void mouseMoved(int x, int y);
        void mouseDragged(int x, int y, int button);
        void mousePressed(int x, int y, int button);
        void mouseReleased(int x, int y, int button);
        void gotOSCMessage(ofxOscMessage m);
        void reset();
    
    //base
    thawAppManager* thaw;
    long long  t_gap;
    
    //tracking
    bool onPhone;
    
    // 3d graphics
    ofLight light; // creates a light and enables lighting
    ofEasyCam cam; // add mouse controls for camera movement
    ofVec3f pos, rot;
    int boxSize;
    bool isSphere;
    
    float mx, my;
    float ang;
    
    //for picture
    bool manual = false;
};
