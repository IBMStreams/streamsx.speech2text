
package RtpDecode_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Annotation; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeEvaluator; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::TupleValue; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   print '/*******************************************************************************', "\n";
   print ' * Copyright (C) 2016, International Business Machines Corporation', "\n";
   print ' * All Rights Reserved', "\n";
   print ' *******************************************************************************/', "\n";
   print '/* Additional includes go here */', "\n";
   print "\n";
   SPL::CodeGen::implementationPrologue($model);
   print "\n";
   print "\n";
   print '// Constructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::MY_OPERATOR()', "\n";
   print '{ ', "\n";
   print '    // Initialization code goes here', "\n";
   print '}', "\n";
   print "\n";
   print '// Destructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::~MY_OPERATOR() ', "\n";
   print '{', "\n";
   print '    // Finalization code goes here', "\n";
   print '}', "\n";
   print "\n";
   print '// Notify port readiness', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::allPortsReady() ', "\n";
   print '{', "\n";
   print '    // Notifies that all ports are ready. No tuples should be submitted before', "\n";
   print '    // this. Source operators can use this method to spawn threads.', "\n";
   print "\n";
   print '    /*', "\n";
   print '      createThreads(1); // Create source thread', "\n";
   print '    */', "\n";
   print '}', "\n";
   print ' ', "\n";
   print '// Notify pending shutdown', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::prepareToShutdown() ', "\n";
   print '{', "\n";
   print '    // This is an asynchronous call', "\n";
   print '}', "\n";
   print "\n";
   print '// Processing for source and threaded operators   ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(uint32_t idx)', "\n";
   print '{', "\n";
   print '    // A typical implementation will loop until shutdown', "\n";
   print '    /*', "\n";
   print '      while(!getPE().getShutdownRequested()) {', "\n";
   print '          // do work ...', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   print 'int16_t  MY_OPERATOR_SCOPE::MY_OPERATOR::MuLaw_Decode(int8_t number)', "\n";
   print '{', "\n";
   print '   const uint16_t MULAW_BIAS = 33;', "\n";
   print '   uint8_t sign = 0, position = 0;', "\n";
   print '   int16_t decoded = 0;', "\n";
   print '   number = ~number;', "\n";
   print '   if (number & 0x80)', "\n";
   print '   {', "\n";
   print '      number &= ~(1 << 7);', "\n";
   print '      sign = -1;', "\n";
   print '   }', "\n";
   print '   position = ((number & 0xF0) >> 4) + 5;', "\n";
   print '   decoded = ((1 << position) | ((number & 0x0F) << (position - 4))', "\n";
   print '             | (1 << (position - 5))) - MULAW_BIAS;', "\n";
   print '   return (sign == 0) ? (decoded) : (-(decoded));', "\n";
   print '} ', "\n";
   print "\n";
   print '// Tuple processing for mutating ports ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple & tuple, uint32_t port)', "\n";
   print '{ ', "\n";
   print '	IPort0Type const & ituple = static_cast<IPort0Type const&>(tuple);', "\n";
   print '	char * incomingPayload = (char *)ituple.get_payload().getData(); ', "\n";
   print '	unsigned char * decompressed = (unsigned char *)malloc(5000);  ', "\n";
   print '   ', "\n";
   print '	int length = ituple.get_payloadLength(); ', "\n";
   print '//	       std::cout << "gggg " <<  length << std::endl; ', "\n";
   print 'for ( int i = 0; i < length; i++ ) ', "\n";
   print '	{  ', "\n";
   print '	   int8_t oneByte = (int8_t)incomingPayload[i]; 	', "\n";
   print '	   int16_t twoBytes =  MuLaw_Decode(oneByte);         ', "\n";
   print '//	   float tempFloat = (float)twoBytes;', "\n";
   print '	   *(int16_t *)(decompressed+(i*2)) = twoBytes;         ', "\n";
   print '	}', "\n";
   print '	OPort0Type otuple;', "\n";
   print '	otuple.set_ssrc(ituple.get_ssrc());', "\n";
   print ' 	otuple.set_ts(ituple.get_ts()); ', "\n";
   print '  	otuple.set_seq(ituple.get_seq()); ', "\n";
   print '       otuple.set_ipSrc_addr(ituple.get_ipSrc_addr());', "\n";
   print '        otuple.set_captureSeconds(ituple.get_captureSeconds());', "\n";
   print "\n";
   print '	otuple.set_payloadLength(length);', "\n";
   print '	otuple.set_payload(blob(decompressed, length * sizeof(int16_t)));', "\n";
   print '	submit(otuple, 0);', "\n";
   print '       free(decompressed);', "\n";
   print "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for non-mutating ports', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple const & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print '    // Sample submit code', "\n";
   print '    /* ', "\n";
   print '      OPort0Type otuple;', "\n";
   print '      submit(otuple, 0); // submit to output port 0', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   print '// Punctuation processing', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Punctuation const & punct, uint32_t port)', "\n";
   print '{', "\n";
   print '    /*', "\n";
   print '      if(punct==Punctuation::WindowMarker) {', "\n";
   print '        // ...;', "\n";
   print '      } else if(punct==Punctuation::FinalMarker) {', "\n";
   print '        // ...;', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   SPL::CodeGen::implementationEpilogue($model);
   print "\n";
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
