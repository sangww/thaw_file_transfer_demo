#pragma once

#include "ofMain.h"
#include "thawAppInterface.h"
#include "thawAppManager.h"

class htmlApp : public thawAppInterface{
    
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
    
    ofImage jpg1, jpg2;
};
