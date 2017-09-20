# streamsx.speech2text Repository
This repository provides supporting applications/solutions, as well as microservices
for effective transformation and analysis of speech to text in a Streams application
using the product-included Speech2Text Toolkit. 

Check out this video about how Verizon is using Speech2Text in Streams: https://youtu.be/Zg-_BJt6jdc

## This is NOT the Speech2Text Toolkit
Using the Speech2Text toolkit with the WatsonS2T operator requires purchase of the IBM Streams product and is included
as a separate download (no extra cost). 

## Build toolkit

1. Install cyrus-sasl-devel.x86_64 (this is only needed for the dps toolkit, i.e. the CallState application):
  yum install cyrus-sasl-devel.x86_64
2. Run ant:
  ant
