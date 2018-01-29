###############################################################################
#                                                                             #
#  Multiple Hypothesis Tracking [http://cpl.cc.gatech.edu/projects/MHT/]      #
#  Contact: Chanho Kim (chkim@gatech.edu)                                     #
#                                                                             #
###############################################################################


1. Requirements

(1) MATLAB
(2) Cliquer (http://users.aalto.fi/~pat/cliquer.html)
(3) Qualex  (http://www.stasbusygin.org/)

Cliquer and Qaulex are already included in the "external" folder.


2. Quick start

(1) Make sure that Cliquer (external/matlab-cliquer/+Cliquer/cliquer) and 
    Qualex (external/qualex-ms) run on your platform.
    Mex files for 64-bit Linux are provided. 
(2) Download the MOT Challenge dataset (motchallenge.net) or 
    the PETS 2009 dataset (http://www.cvg.reading.ac.uk/PETS2009/a.html). 
(3) Download detection files from the MHT project webpage and 
    place them in the "input" folder.
(3) Set input and output file paths in setPathVariables.m. 
(4) Set parameters in setOtherParameters.m.
(5) Run main.m.

   
3. References

[1] Chanho Kim, Fuxin Li, Arridhana Ciptadi, and James M. Rehg. 
    "Multiple Hypothesis Tracking Revisited," ICCV 2015. 


4. Version history

Version 1.0 (01/26/2016)
----
initial release


5. Known issues

(1) Invalid mex file   
libgfortran.so.3: version `GFORTRAN_1.4' not found 
(required by MHT/external/qualex-ms/qualex_ms.mexa64)

In this case, start MATLAB with the following command. 
"LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libfreetype.so:/usr/lib/x86_64-linux-gnu/libgfortran.so.3:/usr/lib/x86_64-linux-gnu/libstdc++.so.6 matlab"

