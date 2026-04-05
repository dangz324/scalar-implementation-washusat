# WashU Satellite - SCALAR Comms
An implementation of WashU Satellite's SCALAR communications stack using PROVES and F' Zephyr.  
The full comms stack is split into 3 layers:  
- CDH Layer: categorizes/converts data to packets  
- Communications Layer: transforms data packets into CCSDS packet frames  
- Transport Layer: transmits data to physical machine  