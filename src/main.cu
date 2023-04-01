#include <iostream>
#include "Engine.h"


int main(int argc, char** argv) {
	Engine engine;
	engine.init(1280, 720);
	engine.setBackgroundColor(0.2f, 0.3f, 0.3f, 1.f);
	engine.run();
	return 0;
}