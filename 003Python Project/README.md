<!--
 * @Author: Changhongli lic9@tcd.com
 * @Date: 2024-01-25 17:08:28
 * @LastEditors: Changhongli lic9@tcd.com
 * @LastEditTime: 2024-03-13 21:15:15
 * @FilePath: /003Python Project/README.md
 * @Description: 
 * 
-->
# Python Project
Computational Method Matting Project
## Project Introduction
This project is built for baysian matting with python.
## Preparation before Getting Started 
### 1. Clone the project to your own path
* clone the project
  ```sh
  git clone https://github.com/CNStanLee/CM_Matting.git
  ```
### 2. CD to 003Python Project\python_project path
### 3. Install the required libs
* install libs
  ```sh
  pip install -r requirements.txt
  ```
## Getting Started (Script Version)
### 1. Open script
Open bay_matting_demo.ipynb file
### 2. Change the parameters
Change the parameter in the input field
* change the parameter
  ```sh
    image_path = 'Dataset/input_training_lowres/GT01.png'
    trimap_path = 'Dataset/AlphaMap_lowres/GT01.png'
  ```
### 3. Execute each code block in sequence
## Execute Unitest
* Execute Unitest
  ```sh
    conda activate dl
    python bay_matting_unitest.py
  ```
## Evaluate the Performance(in progress)