#include "axon.h"

void connectAxon( unsigned char axonNum, 
				  unsigned char sourcePerceptron, 
				  unsigned char targetPerceptron, 
				  unsigned char inputNum, 
				  unsigned char mode )
{
	Axon* axon = BANKED_AXON( axonNum );
	axon->sourcePerceptron 	= sourcePerceptron;
	axon->targetPerceptron 	= targetPerceptron;
	axon->INPUT_NUM 		= inputNum;
	axon->MODE 				= mode;
}
