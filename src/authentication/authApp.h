#pragma once

#include "ofMain.h"
#include "thawAppInterface.h"
#include "thawAppManager.h"

class authApp : public thawAppInterface{
    
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
    
    vector<ofPoint> pt;
    
    ofTrueTypeFont	font;
    
    int mode = 0;
    int pos_slide = 0;
    
    float rx = 10.f;
    float gx = 0.f;
    float cr = 90.f;
    float ry = 0.f;
    float gy = 10.f;
    float cg = 90.f;
    
    float px, py;
};
