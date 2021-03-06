#include "dragdropApp.h"

//--------------------------------------------------------------
void dragdropApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    //icon
    for (int i =0; i<NUM_ICON ; i++){
        icons[i].loadImage("icon"+ofToString(i)+".png");
        pos_icons[i].x = 160*i;
        pos_icons[i].y = 50;
        loc_icons[i] = true;
    }
    selected = -1;
    selectedRemote = -1;
}

//--------------------------------------------------------------
void dragdropApp::update(){
    
    if(ofGetSystemTime() - t_gap > 50){
        ofxOscMessage m;
        m.setAddress( "/mouse/host/move" );
        m.addIntArg(onPhone);
        m.addIntArg(mouseX-thaw->phoneX);
        m.addIntArg(mouseY-thaw->phoneY);
        m.addIntArg(selected);
        m.addIntArg(pivot_x - drag_x);
        m.addIntArg(pivot_y - drag_y);
        
        thaw->send( m );
        
        
        if(!onPhone){
            m.clear();
            m.setAddress( "/mouse/host/icon" );
            
            if(selected>=0) {
                m.addIntArg(pos_icons[selected].x);
                m.addIntArg(pos_icons[selected].y);
                m.addIntArg(selected);
                thaw->send( m );
            }
            else if(selectedRemote>=0){
                m.addIntArg(pos_icons[selectedRemote].x);
                m.addIntArg(pos_icons[selectedRemote].y);
                m.addIntArg(selectedRemote);
                thaw->send( m );
            }
        }
        
        t_gap= ofGetSystemTime();
    }
}

void dragdropApp::gotOSCMessage(ofxOscMessage m){
    if(m.getAddress() == "/mouse/client/select"){
        selectedRemote = m.getArgAsInt32(0);
        offset_x = m.getArgAsInt32(1)/2;
        offset_y = m.getArgAsInt32(2)/2;
    }
    
    if(m.getAddress() == "/mouse/client/touch"){
        int touched = m.getArgAsInt32(0);
        if(touched>=0 && loc_icons[touched]){
            ofxOscMessage m;
            m.setAddress( "/mouse/host/released" );
            m.addIntArg(1);
            m.addIntArg(touched);
            loc_icons[touched] = false;
            thaw->send( m );
        }
    }
    
    if(m.getAddress() == "/mouse/client/drop"){
        int touched = m.getArgAsInt32(0);
        if(touched>=0 && !loc_icons[touched]){
            pos_icons[touched].x = m.getArgAsInt32(1);
            pos_icons[touched].y = m.getArgAsInt32(2);
            loc_icons[touched] = true;
            
            ofxOscMessage m;
            m.setAddress( "/mouse/host/icon" );
            m.addIntArg(pos_icons[touched].x);
            m.addIntArg(pos_icons[touched].y);
            m.addIntArg(touched);
            thaw->send( m );
        }
    }
}

//--------------------------------------------------------------
void dragdropApp::draw(){
    ofEnableAlphaBlending();
    
    //icons
    ofSetColor(255);
    for (int i=0; i<NUM_ICON; i++){
        if(loc_icons [i])
        icons[i].draw(pos_icons[i].x, pos_icons[i].y, 120, 120);
    }
    
    if(selected >=0){
        ofSetColor(50, 50, 255, 50);
        ofRect(pos_icons[selected].x, pos_icons[selected].y, 120, 120);
    }
    
    if(selectedRemote>=0 && !onPhone){
        icons[selectedRemote].draw(pos_icons[selectedRemote].x,
                                   pos_icons[selectedRemote].y, 120, 120);
        ofSetColor(50, 50, 255, 50);
        ofRect(pos_icons[selectedRemote].x, pos_icons[selectedRemote].y, 120, 120);
    }
    
    if(thaw->debug){
        ofSetColor(255);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY)+ " "+ofToString(onPhone), 10, 40);
        ofDrawBitmapString("selection: " + ofToString(selected) + " " + ofToString(selectedRemote), 10, 60);
    }
}


//--------------------------------------------------------------
void dragdropApp::keyPressed  (int key){
}

//--------------------------------------------------------------
void dragdropApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void dragdropApp::mouseMoved(int x, int y ){
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
void dragdropApp::mouseDragged(int x, int y, int button){
    mouseX = x; mouseY = y;
    
    if(mouseY>thaw->phoneY && mouseY<thaw->phoneY+thaw->phoneH
                            && mouseX>thaw->phoneX && mouseX<thaw->phoneX+thaw->phoneW){
        onPhone = true;
    }
    else{
        onPhone = false;
    }
    
    if(selected>=0){
        pos_icons[selected].x = pivot_x + x - drag_x;
        pos_icons[selected].y = pivot_y + y - drag_y;
    }
    else if(selectedRemote>=0){
        pos_icons[selectedRemote].x = mouseX+offset_x*1.6;
        pos_icons[selectedRemote].y = mouseY+offset_y*1.6;
    }
}

//--------------------------------------------------------------
void dragdropApp::mousePressed(int x, int y, int button){
    vector<ofPoint> poly;
    for (int i=0; i<NUM_ICON; i++){
        poly.clear();
        if(loc_icons[i]){
            poly.push_back( ofPoint(pos_icons[i].x, pos_icons[i].y) );
            poly.push_back( ofPoint(pos_icons[i].x, pos_icons[i].y+120) );
            poly.push_back( ofPoint(pos_icons[i].x+120, pos_icons[i].y+120) );
            poly.push_back( ofPoint(pos_icons[i].x+120, pos_icons[i].y) );

            if(ofInsidePoly(ofPoint(x, y), poly)){
                selected = i;
                drag_x = x;
                drag_y = y;
                pivot_x = pos_icons[i].x;
                pivot_y = pos_icons[i].y;
                return;
            }
        }
    }
    selected = -1;
    
    if(onPhone){
        ofxOscMessage m;
        m.setAddress( "/mouse/host/pressed" );
        thaw->send( m );
    }
}

//--------------------------------------------------------------
void dragdropApp::mouseReleased(int x, int y, int button){
    
    ofxOscMessage m;
    m.setAddress( "/mouse/host/released" );
    if(onPhone){
        m.addIntArg(1);
        m.addIntArg(selected);
        if(selected>=0) loc_icons[selected] = false;
    }
    else{
        m.addIntArg(0);
        m.addIntArg(selectedRemote);
        if(selectedRemote>=0) loc_icons[selectedRemote] = true;
    }
    thaw->send( m );
    
    selected = -1;
    selectedRemote = -1;
}

void dragdropApp::reset(){
    ofBackground(255);
    
    for(int i=0; i<NUM_ICON; i++){
        if(loc_icons[i]){
            
        }
        else{
            pos_icons[i].x = 160*i;
            pos_icons[i].y = 50;
            loc_icons[i] = true;
        }
        ofxOscMessage m;
        m.setAddress( "/mouse/host/icon" );
        m.addIntArg(pos_icons[i].x);
        m.addIntArg(pos_icons[i].y);
        m.addIntArg(i);
        thaw->send( m );
    }
}

