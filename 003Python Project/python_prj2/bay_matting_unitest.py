'''
Author: Changhongli lic9@tcd.com
Date: 2024-03-13 20:44:21
LastEditors: Changhongli lic9@tcd.com
LastEditTime: 2024-03-13 21:00:17
FilePath: /test/python_prj/bay_matting_unitest.py
Description: 

'''
# ------------- import external libs  ----------------- #
import cv2
import numpy as np
from matplotlib import pyplot as plt
import time
from memory_profiler import profile
import psutil
import os
import tracemalloc
import unittest
# ------------- import user libs  --------------------- #
import bay_matting_fun as bm

class TestComputeMeanCov(unittest.TestCase):
    def setUp(self):
        self.unknownImg = np.random.rand(497, 800, 3)
        self.triMap = np.random.randint(0, 256, size=(497, 800))
        self.Fmean = np.random.rand(3)
        self.Bmean = np.random.rand(3)
        self.coF = np.random.rand(3, 3)
        self.coB = np.random.rand(3, 3)
        self.oriVar = 8
        self.Iteration = 10
        self.width = 497
        self.height = 800
        self.image_path = 'Dataset/input_training_lowres/GT01.png'
        self.trimap_path = 'Dataset/AlphaMap_lowres/GT01.png'
        self.threshold = 0.5

    def test_compute_mean_cov(self):
        Fmean, Bmean, coF, coB = bm.compute_mean_cov(self.unknownImg, self.unknownImg, self.unknownImg, self.width, self.height)

        self.assertIsInstance(Fmean, np.ndarray)
        self.assertIsInstance(Bmean, np.ndarray)
        self.assertIsInstance(coF, np.ndarray)
        self.assertIsInstance(coB, np.ndarray)

        self.assertEqual(Fmean.shape, (3,))
        self.assertEqual(Bmean.shape, (3,))
        self.assertEqual(coF.shape, (3, 3))
        self.assertEqual(coB.shape, (3, 3))

    def test_update_alpha(self):
        unknownAlpha, unknownF, unknownB = bm.update_alpha(self.unknownImg, self.triMap, self.Fmean, self.Bmean, self.coF, self.coB, self.oriVar, self.Iteration, self.width, self.height)

        self.assertIsInstance(unknownAlpha, np.ndarray)
        self.assertIsInstance(unknownF, np.ndarray)
        self.assertIsInstance(unknownB, np.ndarray)

        self.assertEqual(unknownAlpha.shape, (self.width, self.height))
        self.assertEqual(unknownF.shape, self.unknownImg.shape)
        self.assertEqual(unknownB.shape, self.unknownImg.shape)

    def test_bayesian_matting(self):
        AlphaMap = bm.bayesian_matting(self.image_path, self.trimap_path)

        self.assertIsInstance(AlphaMap, np.ndarray)
        self.assertEqual(AlphaMap.shape, (self.width, self.height))

    def test_show_foreground_with_threshold(self):
        bm.show_foreground_with_threshold(self.image_path, self.trimap_path, self.threshold)

    def test_compute_mean_cov(self):
        # Create some test data
        width, height = 10, 10
        frontImg = np.ones((width, height, 3)) * 255  # foreground all white
        backImg = np.zeros((width, height, 3))  # background all black
        unknownImg = np.random.randint(0, 255, size=(width, height, 3))  # unkown area random pixels

        # call the func
        Fmean, Bmean, coF, coB = bm.compute_mean_cov(frontImg, backImg, unknownImg, width, height)

        # check return type
        self.assertIsInstance(Fmean, np.ndarray)
        self.assertIsInstance(Bmean, np.ndarray)
        self.assertIsInstance(coF, np.ndarray)
        self.assertIsInstance(coB, np.ndarray)

        # check return shape
        self.assertEqual(Fmean.shape, (3,))
        self.assertEqual(Bmean.shape, (3,))
        self.assertEqual(coF.shape, (3, 3))
        self.assertEqual(coB.shape, (3, 3))
        


if __name__ == '__main__':
    unittest.main()