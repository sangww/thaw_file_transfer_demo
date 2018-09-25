#include "box2dApp.h"

//--------------------------------------------------------------
void box2dApp::setup(){
    thaw = thawAppManager::getInstance();
    t_gap = ofGetSystemTime();

    //Box2D
    myPhoneBound.init(PhoneType::IPHONE4);
    myPhoneBound.setupContainer();
    myPhoneBound.setupBlock();
    
    worldBound.set(0,0, ofGetWidth(), ofGetHeight());
    box2d.init();
    box2d.setFPS(30);
    box2d.setGravity(0, 15);
    box2d.createBounds(worldBound);
    
    particleSize = 50; //Particle on MBP
    iParticleSize = 80; //Particle on iPhone
    
    bDrawBounds = false;
    bDemo1 = true;
    bDemo2 = bDemo3 = false;
}

//--------------------------------------------------------------
void box2dApp::update(){
    
    //box2D
    box2d.update();
    phoneBound.clear();
    
    myPhoneBound.update(thaw->phoneX, thaw->phoneY, thaw->angle);
    
    if(bDemo1 || bDemo2)
    {
        myPhoneBound.updateContainer();
        phoneBound.addVertexes(myPhoneBound.phoneContainer);
    }

    if(bDemo3 || bDemo4)
    {
        myPhoneBound.updateBlock();
        phoneBound.addVertexes(myPhoneBound.phoneBlock);
        
        if (thaw->screenTouch || ofGetMousePressed())
        {
            for(int i = 0; i < circles.size(); i++)
            {
                if (bDemo3) circles[i].get()->addRepulsionForce(myPhoneBound.getCentroid().x, myPhoneBound.getCentroid().y, 50);
                if (bDemo4) circles[i].get()->addRepulsionForce(myPhoneBound.getCentroid().x, myPhoneBound.getCentroid().y, -50);
            }
        }

    }
    
    phoneBound.create(box2d.getWorld());
    

    //SEND PARTICLE
    if(bDemo1 || bDemo2)
    {
        for(int i = 0; i < circles.size(); i++)
        {
            ofVec2f temp1 = circles[i].get()->getPosition() - myPhoneBound.getContainer().getVertices().at(0);
            ofVec2f temp2 = circles[i].get()->getPosition() - myPhoneBound.getContainer().getVertices().at(3);
            float angle = temp1.angle(temp2);
            
            if ((angle < -175 || angle > 175) && circles[i].get()->getVelocity().y > 0)
            {
                //calc iPhone screen x and y
                int iX = ofMap( circles[i].get()->getPosition().x - myPhoneBound.getContainer().getVertices().at(0).x,
                               particleSize, myPhoneBound.width - particleSize,
                               0 + iParticleSize, 480 - iParticleSize);
                
                //cout << iX << endl;
                
                if(ofGetSystemTime() - t_gap > 50){
                    ofxOscMessage m;
                    m.setAddress( "/box2d/host/particle" );
                    m.addIntArg( iX );
                    m.addFloatArg( circles[i].get()->getVelocity().x );
                    m.addFloatArg( circles[i].get()->getVelocity().y );
                    
                    thaw->send( m );
                    t_gap= ofGetSystemTime();
                }
                deleteParticles();
            }
        }
    }
}

void box2dApp::gotOSCMessage(ofxOscMessage m){
    if(m.getAddress() == "/box2d/client/particle")
    {
        int mX = m.getArgAsInt32(0);
        int vX = m.getArgAsFloat(1) / 2; //divide too make weaker
        int vY = m.getArgAsFloat(2) / 2;
        
        float factor = ofMap(mX, 0, 480, 0, 1);
        ofVec2f vecAB;
        ofVec2f vecAnew;
        
        if(bDemo1)
        {
            vecAB = (myPhoneBound.getContainer().getVertices().at(3) - myPhoneBound.getContainer().getVertices().at(0));
            vecAnew = myPhoneBound.getContainer().getVertices().at(0)  + (factor * vecAB);
        }
        
        if(bDemo2)
        {
            vecAB = (myPhoneBound.getContainer().getVertices().at(2) - myPhoneBound.getContainer().getVertices().at(1));
            vecAnew = myPhoneBound.getContainer().getVertices().at(1)  + (factor * vecAB);
        }
        
        int calcX = vecAnew.x;
        int calcY = vecAnew.y +10;
        
        //cout << myPhoneBound.getCentroidTop().y << calcX << endl;
        ofVec2f incomingVel;
        incomingVel.set(vX, vY);
        spawnParticle(calcX, calcY, incomingVel);
    }
}


//--------------------------------------------------------------
void box2dApp::draw(){
    //ofBackground(100,100,100);
    ofEnableAlphaBlending();
    
    /*
    ofSetColor(255);
    ofDrawBitmapString("Demo:  1:" + ofToString(bDemo1) +
                       "  2:" + ofToString(bDemo2) +
                       "  3:" + ofToString(bDemo3) +
                       "  4:" + ofToString(bDemo3), 750, 20);
    */
    
    //-------------
    //BOX2D
    //-------------    
    
    for(int i = 0; i < circles.size(); i++)
    {
		ofFill();
		ofSetHexColor(0xffffff);
		circles[i].get()->draw();
    }
    
    ofSetColor(255, 255, 255);
    phoneBound.updateShape();
    /*
    //physical token (1)
    ofSetColor(255, 255, 0);
    ofCircle(503, 303, 50);
    ofNoFill();
    ofSetColor(200, 200, 200);
    ofCircle(503, 303, 50);
    ofFill();
    
    ofSetColor(255, 255, 0);
    ofCircle(500, 300, 50);
    ofNoFill();
    ofSetColor(100, 100, 100);
    ofCircle(500, 300, 50);
    ofFill();
     */
    
    /*
    ofSetColor(255, 255, 0);
    ofCircle(1000, 500, 50);
    ofNoFill();
    ofSetLineWidth(3);
    ofSetColor(100, 100, 100);
    ofCircle(1000, 500, 50);
    ofFill();
     */
    
    if(thaw->debug){
        if(thaw->fullscreenpattern) ofSetColor(255);
        else ofSetColor(0);
        ofDrawBitmapString("fps: " + ofToString(ofGetFrameRate()), 10, 20);
        ofDrawBitmapString("track: " + ofToString(thaw->phoneX) + " " + ofToString(thaw->phoneY), 10, 40);
        ofDrawBitmapString("dist: " + ofToString(thaw->distance), 10, 60);
        ofDrawBitmapString("touch: " + ofToString(thaw->touchX)+" "+ofToString(thaw->touchY), 10, 80);
        ofDrawBitmapString("acc: " + ofToString(thaw->accelX)+" "+ofToString(thaw->accelY), 10, 100);
        ofDrawBitmapString("cal: " + ofToString(thaw->axr)+" "+ofToString(thaw->axg)+" "+
                           ofToString(thaw->byr)+" "+ofToString(thaw->byg), 10, 120);
        ofDrawBitmapString("rgb: " + ofToString(thaw->r)+" "+ofToString(thaw->g)+" "+
                           ofToString(thaw->b), 10, 140);
        ofDrawBitmapString("on: " + ofToString(thaw->onScreenMode) + " " + ofToString(thaw->onTrackPattern), 10, 160);
        ofDrawBitmapString("out : " + ofToString(thaw->out_index[0]) + " " + ofToString(thaw->out_index[1])
                           + " " + ofToString(thaw->out_index[2]) + " " + ofToString(thaw->out_index[3]), 10, 180);
    }
}


//--------------------------------------------------------------
void box2dApp::keyPressed  (int key){
    
}

//--------------------------------------------------------------
void box2dApp::keyReleased  (int key){
    
    if (key == '1')
    {
        bDemo1 = true;
        bDemo2 = bDemo3 = bDemo4 = false;
        
        ofxOscMessage m;
        m.setAddress( "/box2d/host/key" );
        m.addIntArg(1);
        
        thaw->send( m );
    } 
    
    //create balls
    if(key == 'b')
    {
        spawnParticle(ofGetScreenWidth()/2, 0, ofVec2f(0));
    }
}

//--------------------------------------------------------------
void box2dApp::mouseMoved(int x, int y ){
}

//--------------------------------------------------------------
void box2dApp::mouseDragged(int x, int y, int button){
}

//--------------------------------------------------------------
void box2dApp::mousePressed(int x, int y, int button){
}

//--------------------------------------------------------------
void box2dApp::mouseReleased(int x, int y, int button){
}

//--------------------------------------------------------------
void box2dApp::deleteParticles()
{
    for (int i = 0; i < circles.size(); i ++)
    {
        circles.clear();
    }
}

//--------------------------------------------------------------
void box2dApp::spawnParticle(int _x, int _y, ofVec2f _velocity)
{
    deleteParticles();
    
    float r = particleSize;
    circles.push_back(ofPtr<ofxBox2dCircle>(new ofxBox2dCircle));
    ofxBox2dCircle * circle = circles.back().get();
    circle->setPhysics(3.0, 0.3, 0.1);
    circle->setup(box2d.getWorld(), _x, _y, r);
    circle->setVelocity(_velocity);
}
void box2dApp::reset(){
    ofBackground(255);
}
