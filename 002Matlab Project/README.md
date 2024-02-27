# Matlab Project
## Project Introduction
This project is built for baysian matting with matlab.
## Preparation before Getting Started 
### 1. Clone the project to your own path
* clone the project
  ```sh
  git clone https://github.com/CNStanLee/CM_Matting.git
  ```
### 2. CD to 002Matlab Project\project path
### 3. (*IMPORTANT*) Add to path
Must Select All the folder and right click on the folder, choose "Add to Path", then choose "selected folders and subfolders"
## Getting Started (GUI Version)
### 1. Start GUI Applicaiton
Double click Wangba.mlapp to start the application, if you enter the design page, you can click the green run button on the top.
### 2. Basic Setup
You need to import the original picture and Trimap picture with the button input, background could be chose, but if you don't give back ground
* OringinValue: User Input, original pixel values are often used in the calculation of probability models between different regions of the image to perform more accurate image matting operations.
* Iteration: How many times to perform the iteration to calculate and update alpha map.
### 3. Start
Click start button to start the matting
### 4. Preview and Export the result
* AlphaMap: The result alpha map of the matting result, could be export to compare with the ground truth.
* Result: The result picture which has been matted and replaced with a new background.
## Getting Started (Script Version)
### 1. Open script
Open Demostration.m file
### 2. Change the parameters
Change the parameter in the input field
* change the parameter
  ```sh
    % INPUT
    oriImg = 'origin.png';
    triMap = 'trimapOrigin.png';
    BgPath = "WhiteBg.png";
    Iteration = 10; % USER INPUT %
    oriVar    = 10;  % USER INPUT %
  ```
### 3. Click Run button to excute the matting
## Evaluate the Performance

* Run the command in matlab
  ```sh
    mse = CalculateAlphaMSE(predictedAlphaFile, groundTruthAlphaFile)
  ```

* mse: Mean Squared between the result and the ground truth.
* predictedAlphaFile: File path to the alpha map.
* groundTruthAlphaFile: File path to the ground truth alpha map.