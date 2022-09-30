<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.io.*" %>
    <%@ page import="java.util.*" %>
	<%@ page import="com.oreilly.servlet.*" %>
	<%@ page import="com.oreilly.servlet.multipart.*" %>
	<%@ page import="javax.imageio.*" %>
	<%@ page import="java.awt.image.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%!
///////////////////////
//전역변수부
//////////////////////
int[][][] inImage;
int inH,inW;
int[][][] outImage;
static int outH,outW;
File inFp,outFp;

float[] rgb = new float[3];
float[] hsv = new float[3];
float[] abc = new float[3];
float[] def = new float[3];

//Parameter Variable
String algo, para1, para2;
String inFname, outFname;

/////////////////////////
//영상처리 함수부
/////////////////////////
public void equalImage(){
	outH=inH;
	outW=inW;
	outImage= new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[rgb][i][k]=inImage[rgb][i][k];
		}
	}
	}
}
public void reverseImage(){
	//반전영상
	//중요! 출력영상의 크기 결정 알고리즘에 의존
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//**Image Processing Algorithm**
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i][k]= 255-inImage[rgb][i][k];
			}
		}
	}
}
public void addImage(){
	//Add Image 영상
	//중요! 출력 영상의 크기 결정(알고리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				if(inImage[rgb][i][k]+value>255)
					outImage[rgb][i][k]=255;
				else if(inImage[rgb][i][k]+value<0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=inImage[rgb][i][k]+value;
			}
		}
	}
	
}
public void gopImage(){
	//gop Image 영상
	//중요! 출력 영상의 크기 결정(알고리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				if(inImage[rgb][i][k]*value>255)
					outImage[rgb][i][k]=255;
				else if(inImage[rgb][i][k]*value<0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=inImage[rgb][i][k]*value;
			}
		}
	}
}
public void divImage(){
	//gop Image 영상
	//중요! 출력 영상의 크기 결정(알고리즘에 의존)
	outH=inH;
	outW=inW;
	outImage=new int[3][outH][outW];
	//**Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				if(inImage[rgb][i][k]/value>255)
					outImage[rgb][i][k]=255;
				else if(inImage[rgb][i][k]/value<0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=inImage[rgb][i][k]/value;
			}
		}
	}
}
public void image127(){
	//흑백 127기준변환
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	//** Image Processing Algorithm **
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumValue = inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k];
			int avgValue = sumValue/3;
			
			if(avgValue>127){
				outImage[0][i][k]=255;
				outImage[1][i][k]=255;
				outImage[2][i][k]=255;
			}
			else{
				outImage[0][i][k]=0;
				outImage[1][i][k]=0;
				outImage[2][i][k]=0;
			}
		}
	}
}
public void avgImage(){
	//흑백 평균기준변환
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	int hap=0,avg,cnt=0;
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				hap+=inImage[rgb][i][k];
				cnt++;
			}
		}
	}
	
	avg = hap/cnt;

	//** Image Processing Algorithm **
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumValue = inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k];
			int avgValue = sumValue/3;
			
			if(avgValue>avg){
				outImage[0][i][k]=255;
				outImage[1][i][k]=255;
				outImage[2][i][k]=255;
			}
				
			else{
				outImage[0][i][k]=0;
				outImage[1][i][k]=0;
				outImage[2][i][k]=0;
			}
		}
	}
}
public void paraCupImage(){
	outH=inH;
	outW=inW;

	outImage = new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k]=(int)(Math.pow((double)(inImage[rgb][i][k]/128-1),(double)2)*255);
			}
		}
	}
}
public void paraCapImage(){
	outH=inH;
	outW=inW;

	outImage = new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k]=(int)(255-(255)*Math.pow((double)(inImage[rgb][i][k]/128-1),(double)2));
			}
		}
	}
}
public void gammaImage(){
	//감마
	outH =inH;
	outW =inW;
	// 메모리 할당
	outImage = new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	double value = Double.parseDouble(para1);
	if(value <0)
		value =1/(1-value);
	else
		value +=1;

	//감마 변환
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++){
			for(int k=0; k<inW; k++){
				double result=(Math.pow((double)(inImage[rgb][i][k]/255.0),(double)(value))*255+0.5);
				if(result <0)
					result=0;
				else if(result >255)
					result=255;
				outImage[rgb][i][k] = (int)result;
			}
		}
	}
}
public void lrImage(){
	//영상 좌우   반전
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	//** Image Processing Algorithm **
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[0][i][k]=inImage[0][inH-i-1][k];
			outImage[1][i][k]=inImage[1][inH-i-1][k];
			outImage[2][i][k]=inImage[2][inH-i-1][k];
		}
	}
}
public void udImage(){
	//영상 상하반전
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	//** Image Processing Algorithm **
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			outImage[0][i][k]=inImage[0][i][inW-k-1];
			outImage[1][i][k]=inImage[1][i][inW-k-1];
			outImage[2][i][k]=inImage[2][i][inW-k-1];
		}
	}
}
public void swapImage(){
	//영상이동
	int x = Integer.parseInt(para1);
	int y = Integer.parseInt(para2);
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				if((i+x)<outH && (k+y)<outW)
					outImage[rgb][i+x][k+y]=inImage[rgb][i][k];
				else break;
			}
		}
	}
}
public void spinImage(){
	int CenterH, CenterW, newH, newW , Val;
	double Radian, PI;
	// PI = 3.14159265358979;
	PI = Math.PI;
	int degree = Integer.parseInt(para1);
	
	Radian = -degree * PI / 180.0; 
	outH = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));
	outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));
	CenterH = outH / 2;
	CenterW = outW / 2;
	outImage = new int[3][outH][outW];
	
	for (int rgb = 0; rgb < 3; rgb++) {
		for (int i = 0; i < outH; i++) {
			for (int k = 0; k < outW; k++) {
				newH = (int)((i - CenterH) * Math.cos(Radian) + (k - CenterW) * Math.sin(Radian) + inH / 2);
				newW = (int)(-(i - CenterH) * Math.sin(Radian) + (k - CenterW) * Math.cos(Radian) + inW / 2);
				if (newH < 0 || newH >= inH) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
							
				} else if (newW < 0 || newW >= inW) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
				} else {
					Val = inImage[rgb][newH][newW];
					outImage[rgb][i][k] = Val;
				}
				
			}
		}
	}

}
public void rotateImage(){
	int CenterH, CenterW, newH, newW , Val;
	double Radian, PI;
	// PI = 3.14159265358979;
	PI = Math.PI;
	int degree = Integer.parseInt(para1);
	
	Radian = -degree * PI / 180.0; 
	outH = (int)(Math.floor((inW) * Math.abs(Math.sin(Radian)) + (inH) * Math.abs(Math.cos(Radian))));
	outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));
	CenterH = outH / 2;
	CenterW = outW / 2;
	outImage = new int[3][outH][outW];
	
	for (int rgb = 0; rgb < 3; rgb++) {
		for (int i = 0; i < outH; i++) {
			for (int k = 0; k < outW; k++) {
				newH = (int)((i - CenterH) * Math.cos(Radian) - (k - CenterW) * Math.sin(Radian) + inH / 2);
				newW = (int)((i - CenterH) * Math.sin(Radian) + (k - CenterW) * Math.cos(Radian) + inW / 2);
				if (newH < 0 || newH >= inH) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
							
				} else if (newW < 0 || newW >= inW) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
				} else {
					Val = inImage[rgb][newH][newW];
					outImage[rgb][i][k] = Val;
				}
				
			}
		}
	}

}

public void zoomOutImage(){
	//영상 축소
	int scale = Integer.parseInt(para1);
	outH = (int)inH/scale;
	outW = (int)inW/scale;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][(int)(i/scale)][(int)(k/scale)]=inImage[rgb][i][k];
			}
		}
	}
}
public void zoomInImage(){
	//영상 확대
	int scale = Integer.parseInt(para1);
	outH = inH*scale;
	outW = inW*scale;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i*scale][k*scale]=inImage[rgb][i][k];
			}
		}
	}
}
public void zoomInImage2(){
	//영상확대(백워딩)
	int scale = Integer.parseInt(para1);
	outH = inH*scale;
	outW = inW*scale;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<outH;i++){
		for(int k=0;k<outW;k++){
			outImage[rgb][i][k]=inImage[rgb][(int)(i/scale)][(int)(k/scale)];
		}
	}
	}
}
public void embossingImage(){
	//엠보싱
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{-1.0,0.0,0.0},
			{0.0,0.0,0.0},
			{0.0,0.0,1.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}


	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	//sum=1
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
		}
}
public void blurrImage(){
	//블러링
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{1.0/9,1.0/9,1.0/9},
			{1.0/9,1.0/9,1.0/9},
			{1.0/9,1.0/9,1.0/9}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=1
	// for(int i=0;i<outH;i++)
//	 	for(int k=0;k<outW;k++)
//	 		tmpOutImage[i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
	for(int i=0;i<outH;i++)
		for(int k=0;k<outW;k++){
			if(tmpOutImage[rgb][i][k]>255.0)
				outImage[rgb][i][k]=255;
			else if(tmpOutImage[rgb][i][k]<0.0)
				outImage[rgb][i][k]=0;
			else
				outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
		}
	}
}
public void sharpenImage(){
	//샤프닝
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{-1.0,-1.0,-1.0},
			{-1.0,9,-1.0},
			{-1.0,-1.0,-1.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=1
	// for(int i=0;i<outH;i++)
//	 	for(int k=0;k<outW;k++)
//	 		tmpOutImage[i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}

}
public void gaussianImage(){
	//가우시안
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{1.0/16, 1.0/8, 1.0/16},
			{1.0/8, 1.0/4, 1.0/8},
			{1.0/16, 1.0/8, 1.0/16}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=1
	// for(int i=0;i<outH;i++)
//	 	for(int k=0;k<outW;k++)
//	 		tmpOutImage[i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}

}
public void hpfSharpImage(){
	//고주파샤프닝 알고리즘
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{-1.0/9, -1.0/9, -1.0/9},
			{-1.0/9, 8.0/9, -1.0/9},
			{-1.0/9, -1.0/9, -1.0/9}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=100.0*tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void sadImage(){
	//이동과 차분
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{0.0, -1.0, 0.0},
			{-1.0, 2.0, 0.0},
			{0.0, 0.0, 0.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;
		
		for(int rgb=0;rgb<3;rgb++){
			for(int i=0;i<outH;i++)
				for(int k=0;k<outW;k++){
					if(tmpOutImage[rgb][i][k]>255.0)
						outImage[rgb][i][k]=255;
					else if(tmpOutImage[rgb][i][k]<0.0)
						outImage[rgb][i][k]=0;
					else
						outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
				}
		}
}
public void opImage(){
	//유사연산자
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];


	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double max = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						if(Math.abs(tmpInImage[rgb][i+1][k+1]-tmpInImage[rgb][i+m][k+n])>=max)
							max = Math.abs(tmpInImage[rgb][i+1][k+1]-tmpInImage[rgb][i+m][k+n]);
				tmpOutImage[rgb][i][k]=(int)max;
			}
		}
	}
	// // //sum=0
	// for(int i=0;i<outH;i++)
//	 	for(int k=0;k<outW;k++)
//	 		tmpOutImage[i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void robertsImage(){
	//로버츠 마스크
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{-1.0, 0.0, -1.0},
			{0.0, 2.0, 0.0},
			{0.0, 0.0, 0.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void sobelImage(){
	//소벨 마스크
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{0.0, -2.0, -2.0},
			{2.0, 0.0, -2.0},
			{2.0, 2.0, 0.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void prewittImage(){
	//프리윗 마스크
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
			{0.0, -1.0, -2.0},
			{1.0, 0.0, -1.0},
			{2.0, 1.0, 0.0}
			};
	
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}
	
	
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void laplacianImage(){
	//라플라시안
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
			{0.0, 1.0, 0.0},
			{1.0, -4.0, 1.0},
			{0.0, 1.0, 0.0}
			};

	double [][][]tmpInImage = new double[3][outH+2][outW+2];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++)
					for(int n=0;n<3;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}
}
public void logImage(){
	//로그
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double [][]mask = {
	            {0.0,0.0,-1.0,0.0,0.0},
	            {0.0,-1.0,-2.0,-1.0,0.0},
	            {-1.0,-2.0,16.0,-2.0,-1.0},
	            {0.0,-1.0,-2.0,-1.0,0.0},
	            {0.0,0.0,-1.0,0.0,0.0}
	        };

	double [][][]tmpInImage = new double[3][outH+4][outW+4];

	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+4;i++){
			for(int k=0;k<inW+4;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+2][k+2]=inImage[rgb][i][k];
			}
		}
	}


	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<5;m++)
					for(int n=0;n<5;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}

}
public void dogImage(){
	//도그
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double[][] mask = {
	            {0.0,0.0,0.0,-1.0,-1.0,-1.0,0.0,0.0,0.0},
	            {0.0,-2.0,-3.0,-3.0,-3.0,-3.0,-3.0,-2.0,0.0},
	            {0.0,-3.0,-2.0,-1.0,-1.0,-1.0,-2.0,-3.0,0.0},
	            {-1.0,-3.0,-1.0,9.0,9.0,9.0,-1.0,-3.0,-1.0},
	            {-1.0,-3.0,-1.0,9.0,19.0,9.0,-1.0,-3.0,-1.0},
	            {-1.0,-3.0,-1.0,9.0,9.0,9.0,-1.0,-3.0,-1.0},
	            {0.0,-3.0,-2.0,-1.0,-1.0,-1.0,-2.0,-3.0,0.0},
	            {0.0,-2.0,-3.0,-3.0,-3.0,-3.0,-3.0,-2.0,0.0},
	            {0.0,0.0,0.0,-1.0,-1.0,-1.0,0.0,0.0,0.0}
	            
	};
	
	double [][][]tmpInImage = new double[3][outH+8][outW+8];
	
	int [][][] tmpOutImage = new int[3][outH][outW];
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+8;i++){
			for(int k=0;k<inW+8;k++){
				tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+4][k+4]=inImage[rgb][i][k];
			}
		}
	}
	
	
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<9;m++)
					for(int n=0;n<9;n++)
						S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				tmpOutImage[rgb][i][k]=(int)S;
			}
		}
	}
	// //sum=0
	for(int rgb=0;rgb<3;rgb++)
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++)
				tmpOutImage[rgb][i][k]+=127.0;
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++)
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k]=255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k]=0;
				else
					outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
			}
	}

}
public void strechImage(){
	//스트레칭
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	int LOW = inImage[0][0][0],HIGH=inImage[0][0][0];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++)
			for(int k=0;k<inW;k++){
				if(LOW>inImage[rgb][i][k])
					LOW = inImage[rgb][i][k];
				if(HIGH<inImage[rgb][i][k])
					HIGH=inImage[rgb][i][k];
			}
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double outa = (double)((inImage[rgb][i][k]-LOW)*255/(HIGH-LOW));
				if(outa<0.0)
					outa=0;
				else if(outa>255.0)
					outa=255;
				else
					outa=(int)outa;
				outImage[rgb][i][k] = (int)outa;
			}
		}
	}
}
public void endInImage(){
	//엔드-인
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	//** Image Processing Algorithm **

	int LOW = inImage[0][0][0],HIGH=inImage[0][0][0];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++)
			for(int k=0;k<inW;k++){
				if(LOW>inImage[rgb][i][k])
					LOW = inImage[rgb][i][k];
				if(HIGH<inImage[rgb][i][k])
					HIGH=inImage[rgb][i][k];
			}
	}
	LOW+=50;
	HIGH+=50;
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double outa = (double)((inImage[rgb][i][k]-LOW)*255/(HIGH-LOW));
				if(outa<0.0)
					outa=0;
				else if(outa>255.0)
					outa=255;
				else
					outa=(int)outa;
				outImage[rgb][i][k] = (int)outa;
			}
		}
	}
}
public void equalizeImage(){
	//평활화
	outH=inH;
	outW=inW;

	outImage = new int[3][outH][outW];
	
	int histoR[] = new int[256];
	int histoG[] = new int[256];
	int histoB[] = new int[256];
	
	for(int i=0;i<256;i++){
		histoR[i]=0;
		histoG[i]=0;	
		histoB[i]=0;
	}
		

	for(int i=0;i<inH;i++)
		for(int k=0;k<inW;k++){
			histoR[inImage[0][i][k]]++;
			histoG[inImage[1][i][k]]++;
			histoB[inImage[2][i][k]]++;
		}


	int sumHistoR[] = new int[256];
	int sumHistoG[] = new int[256];
	int sumHistoB[] = new int[256];
	
	for(int i=0;i<256;i++){
		sumHistoR[i]=0;
		sumHistoG[i]=0;
		sumHistoG[i]=0;
	}

	int sumValueR=0;
	int sumValueG=0;
	int sumValueB=0;
	

	for(int i=0;i<256;i++){
		sumValueR += histoR[i];
		sumHistoR[i]=sumValueR;
		
		sumValueG += histoG[i];
		sumHistoG[i]=sumValueG;
		
		sumValueB += histoB[i];
		sumHistoB[i]=sumValueB;

	}

	double normalHistoR[] = new double[256];
	double normalHistoG[] = new double[256];
	double normalHistoB[] = new double[256];
	
	for(int i=0;i<256;i++){
		normalHistoR[i]=0.0;
		normalHistoG[i]=0.0;
		normalHistoB[i]=0.0;
	}

	for(int i=0;i<256;i++){
		double normalR = sumHistoR[i]*(1.0/(inH*inW))*255.0;
		normalHistoR[i] = normalR;
		double normalG = sumHistoG[i]*(1.0/(inH*inW))*255.0;
		normalHistoG[i] = normalG;
		double normalB = sumHistoB[i]*(1.0/(inH*inW))*255.0;
		normalHistoB[i] = normalB;
	}
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[0][i][k]=(int)normalHistoR[inImage[0][i][k]];
				outImage[1][i][k]=(int)normalHistoG[inImage[1][i][k]];
				outImage[2][i][k]=(int)normalHistoB[inImage[2][i][k]];
			}
		}
}
	
}



public void grayImage(){
	outH=inH;
	outW=inW;
	
	outImage = new int[3][outH][outW];
	
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumValue = inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k];
			int avgValue = sumValue/3;
			
			outImage[0][i][k]=avgValue;
			outImage[1][i][k]=avgValue;
			outImage[2][i][k]=avgValue;
		}
	}
	
}

public float[] rgb2hsv(float r, float g, float b) {

	
	float max1 = Math.max(r,g);
	float max2 = Math.max(g,b);
	float max = Math.max(max1,max2);
	
	float min1 = Math.min(r,g);
	float min2 = Math.min(g,b);
	float min = Math.min(min1, min2);
	
	float d = max - min; //Delta RGB value
 
	float h=0, s;
	float v = max / 255;
	
	if (max==0)
		 s = 0;
	else
		 s = d/max;
	   
	
	if(max==min){
		h = 0;
		}

	else if(max==r){
		h = (g - b) + d * (g < b ? 6: 0); h /= 6 * d;
	}
	else if(max==g){
		h = (b - r) + d * 2; h /= 6 * d;
	}
	else{
		h = (r - g) + d * 4; h /= 6 * d;
	}
	
								 
	hsv[0] = (float)(h);
	hsv[1] = (float)(s);
	hsv[2] = (float)(v);
	
	return hsv;
	}


public float[] hsv2rgb(float h, float s, float v)
{
	float r=0, g=0, b=0, f, p, q, t;
	 
	 h=h*360; s=s*100; v=v*100;
	 
     h = Math.max(0, Math.min(360, h));
     s = Math.max(0, Math.min(100, s));
     v = Math.max(0, Math.min(100, v));
        
     	
     h /= 360;   s /= 100;     v /= 100;

     int i = (int) Math.floor(h * 6);
     f = h * 6 - i;
     p = v * (1 - s);
     q = v * (1 - f * s);
     t = v * (1 - (1 - f) * s);
          

     if(i%6==0){
    	 r = v; g = t; b = p;
     }     
     else if(i%6==1){
    	 r = q; g = v; b = p;
     }
     else if(i%6==2){
    	 r = p; g = v; b = t;
     }
     else if(i%6==3){
    	 r = p; g = q; b = v;
     }
     else if(i%6==4){
    	 r = t; g = p; b = v;
     }
     else if(i%6==5){
    	 r = v; g = p; b = q;
     }
     


    
  	rgb[0] = (float) r*255;
  	rgb[1] = (float) g*255;
  	rgb[2] = (float) b*255;


	
    return rgb;
}

public void saturImage() { // 채도 변경 알고리즘
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH = inH;
    outW = inW;

    // 출력 영상의 3차원 메모리 할당
   	outImage = new int[3][inH][inW];
    
    // **** 진짜 영상처리 알고리즘 *****
	float s_value = Float.parseFloat(para1);
 

        for (int i=0; i<inH; i++) {
            for (int k=0; k<inW; k++) {
                float R = inImage[0][i][k];
                float G = inImage[1][i][k];
                float B = inImage[2][i][k];

                // RGB --> HSV
                //rgb2hsv(R,G,B);  // {h : 0~360, s : 0 ~ 1.0, v : 0 ~ 1.0}
               // int HSV[];
               		//System.out.println("R"+R);

                
                abc = rgb2hsv(R,G,B);
                
                float H = abc[0];
                float S = abc[1];
                float V = abc[2];
           	
                
                // 채도를 변경하자
                S = S + s_value;
                
                // HSV --> RGB
                
                		
                def = hsv2rgb(H,S,V);
				int R1 = (int) def[0]; 
				int G1 = (int) def[1];
				int B1 = (int) def[2];

                // 출력 영상에 넣기
                outImage[0][i][k] = R1;
                outImage[1][i][k] = G1;
                outImage[2][i][k] = B1;
            }
        }            
    // ******************************
}
public void intensityImage() { // 명도 변경 알고리즘
    // (중요!) 출력 이미지의 크기가 결정 ---> 알고리즘에 의존...
    outH = inH;
    outW = inW;

    // 출력 영상의 3차원 메모리 할당
   	outImage = new int[3][inH][inW];
    
    // **** 진짜 영상처리 알고리즘 *****
	float v_value = Float.parseFloat(para1);
 

        for (int i=0; i<inH; i++) {
            for (int k=0; k<inW; k++) {
                float R = inImage[0][i][k];
                float G = inImage[1][i][k];
                float B = inImage[2][i][k];

                // RGB --> HSV
                //rgb2hsv(R,G,B);  // {h : 0~360, s : 0 ~ 1.0, v : 0 ~ 1.0}
               // int HSV[];
               		//System.out.println("R"+R);

                
                abc = rgb2hsv(R,G,B);
                
                float H = abc[0];
                float S = abc[1];
                float V = abc[2];
           	
                
                // 채도를 변경하자
                V = V + v_value;
                
                // HSV --> RGB
                
                		
                def = hsv2rgb(H,S,V);
				int R1 = (int) def[0]; 
				int G1 = (int) def[1];
				int B1 = (int) def[2];

                // 출력 영상에 넣기
                outImage[0][i][k] = R1;
                outImage[1][i][k] = G1;
                outImage[2][i][k] = B1;
            }
        }            
    // ******************************
}
public void orangeImage(){
	outH=inH;
	outW=inW;
	
	outImage= new int[3][outH][outW];
	
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int R = inImage[0][i][k];
			int G = inImage[1][i][k];
			int B = inImage[2][i][k];
			
			hsv = rgb2hsv(R,G,B);
			float H = hsv[0];
			float S = hsv[1];
			float v = hsv[2];
			
			if(8<=(H*360)&&(H*360)<=30){
				outImage[0][i][k]=R;
				outImage[1][i][k]=G;
				outImage[2][i][k]=B;
				
			}
			else{
				int avg =(R+G+B)/3;
				outImage[0][i][k]=avg;
				outImage[1][i][k]=avg;
				outImage[2][i][k]=avg;
				
			}
		}
	}
}
	
%>
<%
//////////////////////////////
//메인코드부
/////////////////////////////
//(0)파라미터 넘겨 받기
MultipartRequest multi = new MultipartRequest(request, "C:/Upload", 
		5*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames(); //주의! 파라미터 순서가 반대
tmp = (String) params.nextElement();
para2 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
para1 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
algo = multi.getParameter(tmp);
// File
Enumeration files = multi.getFileNames(); // 여러개 파일
tmp = (String) files.nextElement(); // 첫 파일 한개
String filename = multi.getFilesystemName(tmp);// 파일명을 추출

//(1)입력 영상 파일 처리
inFp = new File("C:/Upload/"+filename);
BufferedImage bImage = ImageIO.read(inFp);
//(2)파일 --> 메모리
//중요! 입력 영상의 폭과 높이를 알아내야함!
inW = bImage.getHeight();
inH = bImage.getWidth();
//메모리 할당
inImage = new int[3][inH][inW];

//읽어오기
for(int i=0; i<inH; i++) {
	for (int k=0; k<inW; k++) {
		int rgb = bImage.getRGB(i,k);  // F377D6 
		int r = (rgb >> 16) & 0xFF; // >>2Byte --->0000F3 & 0000FF --> F3
		int g = (rgb >> 8) & 0xFF; // >>1Byte --->00F377 & 0000FF --> 77			
		int b = (rgb >> 0) & 0xFF; // >>0Byte --->F377D6 & 0000FF --> D6
		inImage[0][i][k] = r;
		inImage[1][i][k] = g;
		inImage[2][i][k] = b;
	}
}

//Image Processing
switch(algo){
case "101"://동일영상
	equalImage();break;
case "102"://반전영상
	reverseImage();break;
case "103"://영상 더하기/빼기
	addImage();break;
case "104"://영상 곱하기
	gopImage();break;
case "105"://영상 나누기
	divImage();break;
case "106"://흑백127기준
	image127();break;
case "107"://흑백 평균 기준
	avgImage();break;
case "108"://파라볼라 컵
	paraCupImage();break;
case "109"://파라볼라 캡
	paraCapImage();break;
case "110"://감마
	gammaImage();break;
	
	
case "201"://상하미러링
	udImage();break;
case "202"://좌우미러링
	lrImage();break;
case "203"://영상이동
	swapImage();break;
case "204"://영상 시계방향회전
	rotateImage();break;
case "205"://영상 반시계방향 회전
	spinImage();break;
case "207"://영상축소
	zoomOutImage();break;
case "208"://영상확대
	zoomInImage();break;
case "209"://영상확대(백워딩)
	zoomInImage2();break;
	
	
case "301"://엠보싱
	embossingImage();break;
case "302"://블러링
	blurrImage();break;
case "303"://샤프닝
	sharpenImage();break;
case "304"://가우시안
	gaussianImage();break;
case "305"://고주파 샤프닝
	hpfSharpImage();break;
case "306"://이동과 차분
	sadImage();break;
case "307"://유사연산자
	opImage();break;
case "308"://로버츠 알고리즘
	robertsImage();break;
case "309"://소벨 알고리즘
	sobelImage();break;
case "310"://프리윗 알고리즘
	prewittImage();break;
case "311"://라플라시안 알고리즘
	laplacianImage();break;
case "312"://로그 알고리즘
	logImage();break;
case "313"://도그 알고리즘
	dogImage();break;
	
	
case "401"://스트레칭
	strechImage();break;
case "402"://엔드-인
	endInImage();break;
case "403"://평활화
	equalizeImage();break;
	
	
case "501"://채도변환
	saturImage();break;
case "502"://그레이스케일
	grayImage();break;
case "503"://명도변환
	intensityImage();break;
case "504"://오렌지이미지추출
	orangeImage();break;
	

}
//(4)결과를 파일로 저장하기
outFp = new File("C:/out/out_"+filename);

BufferedImage oImage 
= new BufferedImage(outH, outW, BufferedImage.TYPE_INT_RGB); // Empty Image
//Memory --> File
for (int i=0; i< outH; i++) {
for (int k=0; k< outW; k++) {
	int r = outImage[0][i][k];  // F3
	int g = outImage[1][i][k];  // 77
	int b = outImage[2][i][k];  // D6
	int px = 0;
	px = px | (r << 16);  // 000000 | (F30000) --> F30000
	px = px | (g << 8);   // F30000 | (007700) --> F37700
	px = px | (b << 0);   // F37700 | (0000D6) --> F377D6
	oImage.setRGB(i,k,px);
}
}
ImageIO.write(oImage, "jpg", outFp);

out.println("<h1>" + filename + " 영상 처리 완료 !! </h1>");
String url="<p><h2><a href='http://192.168.56.102:8080/";
url += "GrayImageProcessing/download.jsp?file="; 
url += "out_" + filename + "'> !! 다운로드 !! </a></h2>";

out.println(url);


%>

</body>
</html>