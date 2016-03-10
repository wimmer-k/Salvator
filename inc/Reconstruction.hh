#ifndef __RECONSTRUCTION_HH
#define __RECONSTRUCTION_HH
#include <iostream>
#include <iomanip>


//#include "TTree.h"
#include "TEnv.h"

#include "DALIdefs.h"
#include "DALI.hh"
#include "Settings.hh"
/*!
  A class for reconstruction of DALI data, includes Doppler correction and add-back
*/
class Reconstruction {
public:
  //! default constructor
  Reconstruction(){};
  //! constructor
  Reconstruction(char* settings);
  //! dummy destructor
  ~Reconstruction(){
  };
  //! manually set the beta
  void SetBeta(double beta){fbeta = beta;}
  //! read the average positions within the crystals
  void ReadPositions(const char *infile);
  //! sort by energy highest first
  vector<DALIHit*> Sort(vector<DALIHit*> dali);
  //! sort by energy lowest first
  vector<DALIHit*> Revert(vector<DALIHit*> dali);
  //! filter over and underflows
  vector<DALIHit*> FilterOverUnderflows(vector<DALIHit*> hits);
  //! set the positions
  void SetPositions(DALI* dali);
  //! apply the Doppler correction
  void DopplerCorrect(DALI* dali);
  //! check the positions of two hits and decide if they are added back
  bool Addback(DALIHit* hit0, DALIHit* hit1);
  //! do the adding back
  vector<DALIHit*> Addback(vector<DALIHit*> dali);
  
  // //! read in the addback table
  // void ReadAddBackTable();

private:
  //! settings for reconstruction
  Settings* fset;
  //! average beta for Doppler correction
  double fbeta;
  //! average positions of first interaction points
  vector<vector<double> > fpositions;

};
#endif
