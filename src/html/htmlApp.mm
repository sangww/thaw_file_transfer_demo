#include "htmlApp.h"

//--------------------------------------------------------------
void htmlApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    jpg1.loadImage("google3.png");
}

//--------------------------------------------------------------
void htmlApp::update(){
    if(ofGetSystemTime() - t_gap > 50){
        ofxOscMessage m;
        m.setAddress( "/editor/host/index" );
        m.addIntArg(1);
        
        thaw->send( m );
        t_gap= ofGetSystemTime();
    }
}

void htmlApp::gotOSCMessage(ofxOscMessage m){
    
}

//--------------------------------------------------------------
void htmlApp::draw(){
    ofEnableAlphaBlending();
    
    ofSetColor(255);
    jpg1.draw(0, 0, ofGetScreenWidth(), ofGetScreenHeight());
    
    thaw->drawPartScreenPatternAfter();
    
    if(thaw->debug){
        ofSetColor(255);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY), 10, 40);
        ofDrawBitmapString("dist: " + ofToString(thaw->distance), 10, 60);
        ofDrawBitmapString("touch: " + ofToString(thaw->touchX)+" "+ofToString(thaw->touchY), 10, 80);
    }
}


//--------------------------------------------------------------
void htmlApp::keyPressed  (int key){
    
}

//--------------------------------------------------------------
void htmlApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void htmlApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void htmlApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void htmlApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void htmlApp::mouseReleased(int x, int y, int button){
    
}

void htmlApp::reset(){
    ofBackground(255);
}

