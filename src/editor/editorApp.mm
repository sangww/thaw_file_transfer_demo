#include "editorApp.h"

//--------------------------------------------------------------
void editorApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    ofSetColor(255);
    jpg1.loadImage("picture1.jpg");
    rgb1.setFromPixels(jpg1.getPixels(), jpg1.getWidth(), jpg1.getHeight());
    jpg2.loadImage("picture2.jpg");
    rgb2.setFromPixels(jpg2.getPixels(), jpg2.getWidth(), jpg2.getHeight());
    
    noise.allocate(jpg1.getWidth(), jpg1.getHeight());
}

//--------------------------------------------------------------
void editorApp::update(){
    if(thaw->screenTouch){
        float b= thaw->touchX/(float)520;
        float c = thaw->touchY/(float)360;
        
        if(thaw->phoneX<500){
            c1 = c;
            b1 = b;
        }
        else{
            c2 = c;
            b2 = b;
        }
    }
    
    if(ofGetSystemTime() - t_gap > 50){
        ofxOscMessage m;
        m.setAddress( "/editor/host/index" );
        m.addIntArg(0);
        
        thaw->send( m );
        t_gap= ofGetSystemTime();
    }
}

void editorApp::gotOSCMessage(ofxOscMessage m){
    
    if(m.getAddress() == "/edit/client/shake"){
        if(shakeable){
            
            noiselevel++;
            for(int y=0; y<noise.getHeight(); y++){
                for(int x = 0; x<noise.getWidth(); x++){
                    unsigned char* p = noise.getPixels();
                    p[(int)(y*noise.getWidth() + x)] = ofRandom(noiselevel*10);
                }
            }
        }

    }
}

//--------------------------------------------------------------
void editorApp::draw(){
    ofEnableAlphaBlending();
    
    ofSetColor(255);
    
    float r, g, b;
    
    
    ofxCvGrayscaleImage gray1, gray2;
    gray1.setFromColorImage(rgb1);
    gray2.setFromColorImage(rgb2);
    
    for(int y=0; y<noise.getHeight(); y++){
        for(int x = 0; x<noise.getWidth(); x++){
            unsigned char* p = gray1.getPixels();
            p[(int)(y*noise.getWidth() + x)] = min(255,p[(int)(y*noise.getWidth() + x)] + noise.getPixels()[(int)(y*noise.getWidth() + x)]);
        }
    }
    
    gray1.brightnessContrast(b1, c1);
    gray2.brightnessContrast(b2, c2);

    if(!shakeable){
        if(thaw->phoneX<500){
            if(thaw->accelY>0.2) gray1.blur(fabs(thaw->accelY*30-3));
        }
        else{
            if(thaw->accelY>0.2) gray2.blur(fabs(thaw->accelY*30-3));
        }
    }
    
    gray1.draw(190, 0, 480, 640);
    gray2.draw(770, 0, 480, 640);
    
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
void editorApp::keyPressed  (int key){
    if(key=='n'){
        shakeable = !shakeable;
        if(shakeable) thaw->setShowPattern(false);
    }
}

//--------------------------------------------------------------
void editorApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void editorApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void editorApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void editorApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void editorApp::mouseReleased(int x, int y, int button){
    
}

void editorApp::reset(){
    ofBackground(255);
}

