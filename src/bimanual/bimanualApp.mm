#include "bimanualApp.h"

//--------------------------------------------------------------
void bimanualApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    scale = 1.f;
}

//--------------------------------------------------------------
void bimanualApp::update(){
    if(thaw->screenTouch){
        
    }
    
    if(ofGetSystemTime() - t_gap > 50){
        ofxOscMessage m;
        m.setAddress( "/bimanual/host/move" );
        m.addIntArg(onPhone);
        m.addIntArg(mouseX-thaw->phoneX);
        m.addIntArg(mouseY-thaw->phoneY);
        
        thaw->send( m );
        
        t_gap= ofGetSystemTime();
    }

}

void bimanualApp::gotOSCMessage(ofxOscMessage m){
    
    if(m.getAddress() == "/bimanual/client/pinch"){
        scale = m.getArgAsFloat(0);
    }
}

//--------------------------------------------------------------
void bimanualApp::draw(){
    ofEnableAlphaBlending();
    
    float h = ofGetScreenHeight()/2;
    float w = ofGetScreenWidth()/2;
    
    ofSetColor(0);
    ofNoFill();
    ofCircle(w, h, 30*scale);
    ofSetColor(0);
    ofRect(w-12.5*scale, h-8*scale, 7*scale, 7*scale);
    ofRect(w-3.5*scale, h-8*scale, 7*scale, 7*scale);
    ofRect(w+5.5*scale, h-8*scale, 7*scale, 7*scale);
    ofRect(w-12.5*scale, h+1*scale, 7*scale, 7*scale);
    ofRect(w-3.5*scale, h+1*scale, 7*scale, 7*scale);
    ofRect(w+5.5*scale, h+1*scale, 7*scale, 7*scale);
    ofFill();
    
    if(thaw->debug){
        ofSetColor(255);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY), 10, 40);
        ofDrawBitmapString("dist: " + ofToString(thaw->distance), 10, 60);
        ofDrawBitmapString("touch: " + ofToString(thaw->touchX)+" "+ofToString(thaw->touchY), 10, 80);
        ofDrawBitmapString("acc: " + ofToString(thaw->accelX)+" "+ofToString(thaw->accelY), 10, 100);
    }
}


//--------------------------------------------------------------
void bimanualApp::keyPressed  (int key){
    if(key=='+'){
        scale+=0.2;
    }
    else if(key=='-'){
        scale-=0.2;
    }
}

//--------------------------------------------------------------
void bimanualApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void bimanualApp::mouseMoved(int x, int y ){
    mouseX = x; mouseY = y;
    if(mouseY>thaw->phoneY && mouseY<thaw->phoneY+thaw->phoneH
       && mouseX>thaw->phoneX && mouseX<thaw->phoneX+thaw->phoneW){
        onPhone = true;
    }
    else{
        onPhone = false;
    }
}

//--------------------------------------------------------------
void bimanualApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void bimanualApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void bimanualApp::mouseReleased(int x, int y, int button){
    
}

void bimanualApp::reset(){
    ofBackground(255);
}

