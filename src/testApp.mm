#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	//ofSetVerticalSync(true);
    
	ofSetFrameRate(30);
    ofSetFullscreen(true);
    
    dropApp.setup();
    box2dApp.setup();
    navigate3dApp.setup();
    editorApp.setup();
    htmlApp.setup();
    authApp.setup();
    bimanualApp.setup();
    
    thawAppManager::getInstance()->setup();
    //thawAppManager::getInstance()->addApp(&box2dApp);
    //thawAppManager::getInstance()->addApp(&navigate3dApp);
    thawAppManager::getInstance()->addApp(&dropApp);
    //thawAppManager::getInstance()->addApp(&editorApp);
    //thawAppManager::getInstance()->addApp(&bimanualApp);

    //thawAppManager::getInstance()->addApp(&htmlApp);
    //thawAppManager::getInstance()->addApp(&authApp);
    thawAppManager::getInstance()->setApp(0);
}

//--------------------------------------------------------------
void testApp::update(){
    thawAppManager::getInstance()->update();
}

//--------------------------------------------------------------
void testApp::draw(){
    thawAppManager::getInstance()->draw();
}

//--------------------------------------------------------------
void testApp::keyPressed  (int key){
    
    //if(key==' '){
    //    thawAppManager::getInstance()->toggleApp();
    //}
    
    thawAppManager::getInstance()->keyPressed(key);
}

//--------------------------------------------------------------
void testApp::keyReleased  (int key){
    thawAppManager::getInstance()->keyReleased(key);
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){
    thawAppManager::getInstance()->mouseMoved(x, y);
}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){
    thawAppManager::getInstance()->mouseDragged(x, y, button);
}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
    thawAppManager::getInstance()->mousePressed(x, y, button);
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){
    thawAppManager::getInstance()->mouseReleased(x, y, button);
}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){
    
}