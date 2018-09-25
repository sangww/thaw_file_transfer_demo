#include "authApp.h"

//--------------------------------------------------------------
void authApp::setup(){
    ofEnableAlphaBlending();
    
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();
    
    //font
	font.loadFont("HelveticaNeueMed.ttf", 60, true, true);
	font.setLineHeight(34.0f);
	font.setLetterSpacing(1.1);
    
    pt.clear();
}

//--------------------------------------------------------------
void authApp::update(){
    if(thaw->onTrackPattern && thaw->screenTouch){
        
    }
    
    float smooth = 0.7;
    
    px = smooth*px + (1-smooth)*(rx*(cr - thaw->r) + gx*(cg - thaw->g));
    py = smooth*py + (1-smooth)*(ry*(cr - thaw->r) + gy*(cg - thaw->g));
}

void authApp::gotOSCMessage(ofxOscMessage m){
    /*
    if(m.getAddress() == "/unlock/client/status")
    {
        mode = m.getArgAsInt32(0);
        pos_slide = m.getArgAsInt32(1);
    }
    else if(m.getAddress() == "/unlock/client/touch"){
        if(m.getArgAsInt32(0)>0){
            pt.clear();
        }
        pt.push_back(ofPoint(m.getArgAsInt32(1)*0.7+thaw->phoneX+60, m.getArgAsInt32(2)*0.7+thaw->phoneY+20));
    }
     */
}

//--------------------------------------------------------------
void authApp::draw(){
    ofEnableAlphaBlending();
    ofBackground(0);
    
    /*
    if(mode==0){
        ofSetColor(255);
        //ofRect(pos_slide*2, 0, ofGetScreenWidth(), ofGetScreenHeight());
        
        ofPushMatrix();
        ofTranslate(pos_slide*2, 0);
        thaw->drawPartScreenPatternAfter(0, 0, ofGetScreenWidth(), ofGetScreenHeight());
        ofPopMatrix();
    }
    else if(mode == 1){
        thaw->drawPartScreenPatternAfter(520, 100, 400, 200);
        
        ofSetColor(0);
        ofSetLineWidth(4);
        for(int i=0; i+1<pt.size(); i++){
            ofLine(pt[i].x, pt[i].y, pt[i+1].x, pt[i+1].y);
        }
        ofSetLineWidth(1);
    }
    
    if(thaw->debug){
        ofSetColor(0);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY), 10, 40);
        ofDrawBitmapString("dist: " + ofToString(thaw->distance), 10, 60);
        ofDrawBitmapString("touch: " + ofToString(thaw->touchX)+" "+ofToString(thaw->touchY), 10, 80);
    }
     */
    
    glEnable(GL_BLEND);
    glColorMask(0, 0, 0, 1);
    glBlendFunc(GL_SRC_ALPHA, GL_ZERO);
    glColor4f(0.5,0.5,0.5,0.0f);
    ofRect (500, 200, 500, 300);
    glColorMask(1, 1, 1, 1);
    glBlendFunc(GL_ONE_MINUS_DST_ALPHA, GL_DST_ALPHA);
    
    glBegin(GL_POLYGON);
    glColor3f(1.f,1.f,1.f);
    glVertex3f(0, 0, 0);
    glColor3f(1.f,0.8f,1.f);
    glVertex3f(0, ofGetScreenHeight(), 0);
    glColor3f(0.8f, 0.8f,1.f);
    glVertex3f(ofGetScreenWidth(), ofGetScreenHeight(), 0);
    glColor3f(0.8f,1.f,1.f);
    glVertex3f(ofGetScreenWidth(), 0, 0);
    glEnd();
    
    glDisable(GL_BLEND);
    
    font.drawString("x="+ofToString((int)px)+" y ="+ofToString((int)py), 450, 120);
    
	ofDrawBitmapString(ofToString(thaw->r)+" "+ofToString(thaw->g)+" "+ofToString(thaw->b), 20, 40);
	ofDrawBitmapString(ofToString(px)+" "+ofToString(py), 20, 60);
	ofDrawBitmapString(ofToString(rx)+" "+ofToString(gx)+" "+ofToString(cr), 20, 80);
	ofDrawBitmapString(ofToString(gy)+" "+ofToString(ry)+" "+ofToString(cg), 20, 100);
}


//--------------------------------------------------------------
void authApp::keyPressed  (int key){
    if(key=='1') rx+=0.1f;
    if(key=='q') rx-=0.1f;
    if(key=='2') gx+=0.1f;
    if(key=='w') gx-=0.1f;
    if(key=='3') gy+=0.1f;
    if(key=='e') gy-=0.1f;
    if(key=='4') rx+=0.1f;
    if(key=='r') rx-=0.1f;
    if(key=='5') cr+=0.1f;
    if(key=='t') cr-=0.1f;
    if(key=='6') cg+=0.1f;
    if(key=='y') cg-=0.1f;
}

//--------------------------------------------------------------
void authApp::keyReleased  (int key){
    
}

//--------------------------------------------------------------
void authApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void authApp::mouseDragged(int x, int y, int button){
    if( (x-pt[pt.size()-1].x)*(x-pt[pt.size()-1].x) + (y-pt[pt.size()-1].y)*(y-pt[pt.size()-1].y) > 100){
        pt.push_back(ofPoint(x,y));
    }
}

//--------------------------------------------------------------
void authApp::mousePressed(int x, int y, int button){
    pt.clear();
    pt.push_back(ofPoint(x,y));
}

//--------------------------------------------------------------
void authApp::mouseReleased(int x, int y, int button){
    pt.push_back(ofPoint(x,y));
}

void authApp::reset(){
    ofBackground(255);
}

