#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <stdlib.h>
using namespace std;

std::vector<string> cat;

bool existCat(string c){
	int i;
	for(i=0;i<cat.size();i++){
		if(cat.at(i)!=c){continue;}
		else{return true;}
	}
	if(i==cat.size()){return false;}
}

void addCat(string c){
	if(!existCat(c)){cat.push_back(c);}
}

int main(){
	ifstream inFile("20ng-rec_talk.txt");
	ofstream out1xFile("train1.txt");
	ofstream out2xFile("train2.txt");
	ofstream out3xFile("train3.txt");
	ofstream out4xFile("train4.txt");
	ofstream out5xFile("train5.txt");
	string line;
	string temp;
	std::vector<string> art;
	bool f1=false,f2=false,f3=false,f4=false,f5=false,full=false;
	int c1=0,c2=0,c3=0,c4=0,c5=0;
	if(inFile.is_open()){
		while(!inFile.eof()){
			getline(inFile,line);
			stringstream ss;
			ss.str(line);
			ss >> temp;
			while(!full){
				int r = rand()%5 + 1;
				if(r==1 && !f1){
					addCat(temp);
					// out1xFile << temp;
					// while(ss>>temp){
					// 	out1xFile <<" "<< temp;	
					// }
					// out1xFile <<endl;
					out1xFile << line<<endl;
					c1++;
					f1 = c1>=1446;
					full = ((((f1 && f2) && f3 ) && f4 ) && f5);
					break;
				}
				else if(r==2 && !f2){
					addCat(temp);
					// out1xFile << temp;
					// while(ss>>temp){
					// 	out2xFile << " "<<temp;	
					// }
					// out2xFile <<endl;
					out2xFile << line<<endl;
					c2++;
					f2 = c2>=1446;
					full = ((((f1 && f2) &&	 f3 ) && f4 ) && f5);
					break;	
				}
				else if(r==3 && !f3){
					addCat(temp);
					// out3xFile << temp;	
					// while(ss>>temp){
					// 	out3xFile << " "<<temp;	
					// }
					// out3xFile <<endl;
					out3xFile << line<<endl;
					c3++;
					f3 = c3>=1446;
					full = ((((f1 && f2) && f3 ) && f4 ) && f5);
					break;
				}
				else if(r==4 && !f4){
					addCat(temp);
					// out4xFile << temp;	
					// while(ss>>temp){
					// 	out4xFile << " "<<temp;	
					// }
					// out4xFile <<endl;
					out4xFile << line<<endl;
					c4++;
					f4 = c4>=1446;
					full = ((((f1 && f2) && f3 ) && f4 ) && f5);
					break;
				}
				else if(r==5 && !f5){
					addCat(temp);
					// out5xFile << temp;	
					// while(ss>>temp){
					// 	out5xFile << " "<<temp;	
					// }
					// out5xFile <<endl;
					out5xFile << line <<endl;
					c5++;
					f5 = c5>=1446;
					full = ((((f1 && f2) && f3 ) && f4 ) && f5);
					break;
				}
			}
		}
		
		
		for (int i=0;i<cat.size();i++){
			cout << cat.at(i) <<endl;
		}
		cout << "Total Categoris: "<<cat.size()<<endl;
	}
	else {
		cout << "unable to open file";
	}
	return 1;
}
