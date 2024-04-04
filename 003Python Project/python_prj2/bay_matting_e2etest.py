'''
    Author: Lingyu Gong
    Date: 2024-03-14 10:55
    LastEditors: Lingyu Gong
    LastEditTime: 2024-03-14 10:55
    FilePath: /test/python_prj/bay_matting_e2etest.py
    Description: 
            1. Loads a test image and trimap.
            2. Runs the bayesian_matting function.
            3. Asserts that the output is a 2D numpy array of uint8 type.
            4. Optionally, compares the result with a pre-computed expected result.
            5. Cleans up any resources used in the test.
            
'''

import unittest
import cv2
import numpy as np
import os
from bay_matting_fun import bayesian_matting
from tqdm import tqdm

class TestBayesianMatting(unittest.TestCase):

    def setUp(self):
        # Define the directories
        #self.image_dir = '/home/gongl@ad.mee.tcd.ie/Documents/CM_project/CM_Matting/003Python Project/python_prj/Dataset/input_training_lowres'
        #self.trimap_dir = '/home/gongl@ad.mee.tcd.ie/Documents/CM_project/CM_Matting/003Python Project/python_prj/Dataset/AlphaMap_lowres'
        script_dir = os.path.dirname(os.path.abspath(__file__))
        self.image_dir = os.path.join(script_dir, 'Dataset/input_training_lowres')
        self.trimap_dir = os.path.join(script_dir, 'Dataset/AlphaMap_lowres')
        if not os.path.exists(self.image_dir):
            raise FileNotFoundError(f"The directory {self.image_dir} does not exist.")

        if not os.path.exists(self.trimap_dir):
            raise FileNotFoundError(f"The directory {self.trimap_dir} does not exist.")
        print("Image Directory:", self.image_dir)
        print("Trimap Directory:", self.trimap_dir)
        # List all image files in the directory
        self.image_files = [f for f in os.listdir(self.image_dir) if os.path.isfile(os.path.join(self.image_dir, f))]

    def test_bayesian_matting_on_dataset(self):
        for image_file in tqdm(self.image_files):
            with self.subTest(image_file=image_file):
                image_path = os.path.join(self.image_dir, image_file)
                trimap_path = os.path.join(self.trimap_dir, image_file)  # Assuming same filenames for trimaps

                # Run the bayesian_matting function
                alpha_matte = bayesian_matting(image_path, trimap_path)

                # Perform the necessary assertions
                self.assertIsInstance(alpha_matte, np.ndarray, "Output should be a numpy array")
                self.assertEqual(len(alpha_matte.shape), 2, "Output should be a 2D array")
                self.assertEqual(alpha_matte.dtype, np.uint8, "Output array should be of uint8 type")

                # Additional checks or comparisons can be added here

    def tearDown(self):
        pass

if __name__ == '__main__':
    unittest.main()
