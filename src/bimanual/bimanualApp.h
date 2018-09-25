#pragma once

#include "ofMain.h"
#include "thawAppInterface.h"
#include "thawAppManager.h"

#include "ofxOpenCv.h"

class bimanualApp : public thawAppInterface{
    
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
    
    float scale;
    bool onPhone;
};
