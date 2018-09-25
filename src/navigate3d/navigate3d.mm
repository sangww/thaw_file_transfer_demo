#include "navitage3d.h"

//--------------------------------------------------------------
void navigate3dApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    
    boxSize = 200;
    pos.x = 0; pos.y = 0; pos.z = 0;
    rot.x = 0; rot.y = 0; rot.z = 0;
}

//--------------------------------------------------------------
void navigate3dApp::update(){
    rot.x = (thaw->phoneX - ofGetScreenWidth()/2)/10;
    rot.y = -(thaw->phoneY - ofGetScreenHeight()/2)/10;
    if(!manual) boxSize = 300 - thaw->distance*1.5;
    rot.z = thaw->angle;
}

void navigate3dApp::gotOSCMessage(ofxOscMessage m){
    
}

//--------------------------------------------------------------
void navigate3dApp::draw(){
    ofEnableAlphaBlending();
    
    // reponsive graphics
    ofEnableNormalizedTexCoords();
    
    
	float movementSpeed = .1;
	float cloudSize = ofGetWidth() / 2;
	float maxBoxSize = 500;
	
	cam.begin();
    ofPushMatrix();
    ofRotateZ(90);
    
    float t = ofGetElapsedTimef() * movementSpeed;
    if(boxSize<20) boxSize = 20;
    else if(boxSize > maxBoxSize) boxSize= maxBoxSize;
    
	pos *= cloudSize;
    ofTranslate(pos);
    ofRotateX(rot.x);
    ofRotateY(rot.y);
    ofRotateZ(rot.z);
    
    ofFill();
    int g = (255*thaw->touchX)/520;
    int b = (255*thaw->touchY)/360;
    if(g>255) g= 255;
    if(b>255) b= 255;
    
    if(!manual)ofSetColor(255, g, b);
    else ofSetColor(100, 100, 100);
    //ofSetColor(200,200,200);
    ofDrawBox(boxSize);
    
    ofNoFill();
    ofSetColor(ofColor::fromHsb(sinf(t) * 128 + 128, 255, 255));
    ofDrawBox(boxSize * 1.01f);
    
    ofFill();
    
    ofPopMatrix();
	cam.end();
    
    ofDisableNormalizedTexCoords();
    ofDisableDepthTest();
    
    if(thaw->debug){
        ofSetColor(255);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY), 10, 40);
        ofDrawBitmapString("dist: " + ofToString(thaw->distance), 10, 60);
        ofDrawBitmapString("touch: " + ofToString(thaw->touchX)+" "+ofToString(thaw->touchY), 10, 80);
    }
}


//--------------------------------------------------------------
void navigate3dApp::keyPressed  (int key){
    if(key=='m'){
        manual = !manual;
    }
    if(key=='['){
        boxSize+=10;
    }
    if(key==']'){
        boxSize-=10;
    }
    if(key=='{'){
        ang-=10.f;
    }
    if(key=='}'){
        ang+=10.f;
    }
}

//--------------------------------------------------------------
void navigate3dApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void navigate3dApp::mouseMoved(int x, int y ){
    mx = x;
    my = y;
}

//--------------------------------------------------------------
void navigate3dApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void navigate3dApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void navigate3dApp::mouseReleased(int x, int y, int button){
    
}

void navigate3dApp::reset(){
    ofBackground(255);
}

