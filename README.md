The proposed matching framework
This is the software package of our paper:

Y Ye, L Bruzzone, J Shan, F Bovolo, and Q Zhu. Fast and Robust Matching for Multimodal Remote Sensing Image Registration，TGRS，2019.

Y Ye, L Bruzzone, J Shan, F Bovolo, and Q Zhu. Fast and Robust Matching for Multimodal Remote Sensing Image Registration（full version)，arXiv.

Please cite our paper if you use our code for your research. 
This  algorithm have achieve the invention patent，which  is provided for research purposes only. Any commercial
use is prohibited. If you are interested in a commercial use, please 
contact the copyright holder. 

知识产权声明
  论文介绍的是一种通用的多模态遥感图像匹配框架，已获得专利权，所提出的框架可以利用各种特征描述符如HOG、LSS、CFOG、各种梯度信息，相位信息，边缘信息等
构建逐像素的三维特征表达图（本发明不对具体特征进行限定），然后利用各种相似性测度如相关系数，灰度差平方和，欧式距离、互信息和相位相关等进行模板匹配
（本发明不对具体相似性测度进行限定）。这里考虑计算效率问题，我们推荐使用基于FFT加速的灰度差平方和或者互相关进行匹配。
由于所发明的框架技术已经成功商业化，而且形成了大规模工程化应用，因此在没有发明者同意的情况下，只能将其用于科学研究，不能将其任何形式的项目或者商业化应用。

版本更新说明（Updated instructions）
  在这个软件中，我们也更新了CFOG代码，比之前的版本具有更优越的匹配性能
  In our software，CFOG has been updated， which has better matching performance than the previous version


 
------------------------- Important -------------------------
The code includes some matlab .m files and some .mex file  The code is only for 64-bit windows 

-------------------------------------------------------------

-------------------------- bugs -----------------------------
Please report bugs to yeyuanxin, yeyuanxin110@163.com
------------------------------


Run demo.m in MATLAB and you will see how the proposed matching framewrok works.


yuanxin ye

southwestjiaotong university, Chengdu, China
Nov. 2021
