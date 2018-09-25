#pragma once

#include "ofMain.h"

#include "thawAppManager.h"
#include "dragdropApp.h"
#include "box2dApp.h"
#include "navitage3d.h"
#include "editorApp.h"
#include "htmlApp.h"
#include "authApp.h"
#include "bimanualApp.h"

class testApp : public ofBaseApp{
    
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
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    
    dragdropApp dropApp;
    box2dApp box2dApp;
    navigate3dApp navigate3dApp;
    editorApp editorApp;
    htmlApp htmlApp;
    authApp authApp;
    bimanualApp bimanualApp;
};
