#ifndef _AXON_H_
#define _AXON_H_

//
//   Axons start at 0x9000, and there's 1,024 of them per RAM Bank.
//   - That's 4K bytes.
//
#define TOTAL_AXONS			1024
#define AXON_INDEX(n)		(n << 2)
#define BANKED_AXON(n)		(Axon*)((0x9000 + AXON_INDEX(n)))

//
//  Connect an output to another Perceptron's inputs with an Axon.
//  They're 4 bytes each.
//
typedef struct {

	unsigned char sourcePerceptron;
	unsigned char targetPerceptron;
	int INPUT_NUM:    3; 	// 0-6 = input num.  7 = disabled
	int MODE: 		  3;	// 0 = add. 1 = subtract. 2 = add and halve.  3 = add and double.
	int RESERVED:	  10;

} Axon;

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

#endif
