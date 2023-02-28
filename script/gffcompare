
# -*- coding: utf-8 -*-
n >= 3.6

#####Import Module#####
import glob
import sys
import os
import argparse
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))  # NOQA: E402
from utils.functions import init_logger, init_dir, init_software, auto_pairs, run_cmd_time, decide_strand_specific
#####Description####
usage = '''
@Date    : 2023-02-19 17:03:40
@Author  : yhfu (yhfu2012@gmail.com)
@Link    : http://ianimal.pro
Version: v2.0
Description:
    利用gffcompare将组装好的转录本与注释文件比较以发现新的转录本
# TODO annoted.gtf 与 Sus.gtf的区别
Example:
    python {} [-h] -i INPUT [-t THREADS] -g GTF [-v]

'''.format(__file__[__file__.rfind(os.sep) + 1:])

## Parameter Configuration ##
def get_params():
    #创建解析器
    class HelpFormatter(argparse.RawDescriptionHelpFormatter, argparse.ArgumentDefaultsHelpFormatter):
        pass
    parser = argparse.ArgumentParser(
        formatter_class=HelpFormatter, description=usage)
    #添加参数
    parser.add_argument(
        '-i', '--input', help='input dir', required=True, type=str)
    parser.add_argument(
        '-t', '--threads', help='threads numbers', default=8, type=int)
    parser.add_argument(
        '-g', '--gtf', help='sample.gtf/gff', required=True, type=str)
    parser.add_argument(
        '-o', '--output', help='output dir', default="./", type=str)
    parser.add_argument('-v', '--verbose', help='verbosely print information. -vv for printing debug information',
                        action="count", default=0)
    # 解析参数
    return parser.parse_args()

#####Main#####
def main():
    # 获取参数
    args = get_params()
    # 初始化路径
    bn = os.path.basename(args.input)
    outdir = init_dir(os.path.normpath(f"{args.output}/gffcompare/{bn}"))
    print(outdir)
    # 初始化日志
    logger = init_logger(
        level=args.verbose, filepath=f"{outdir}/{bn}.log", verbose=True)
    # 检测软件
    software = init_software(["stringtie"], ["gffcompare"])
    # 执行生信流程
    gtf = glob.glob(f"{args.input}/*.gtf")[0]
    # 合并转录本
    cmd = f"{sofrware["stringtie"]} --merge -G {args.gtf} -i {gtf} -o merged "
    run_cmd_time(cmd, f"merge for {bn}")
    #- 比对
    cmd = f"{software["gffcompare"]}  -R -r {args.gtf} {outdir}/merged*"
    run_cmd_time(cmd, f"compare for {bn}")

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.stderr.write("User interrupt me! ;-) See you!\n")
        sys.exit(0)

# python >= 2.7

#####Import Module#####
import logging
import sys
import os
import math
import time
import argparse
import glob
import re
from functools import wraps
import numpy as np
import pandas as pd

#####Description####
usage = '''
@Date    : 2022-11-24 16:07:16
@Author  : Your Name (you@example.org)
@Link    : http://example.org
@Version : $Id$
Description:

Example:
    python {} [-i input] [-o output]
Step:

'''.format(__file__[__file__.rfind(os.sep) + 1:])


class HelpFormatter(argparse.RawDescriptionHelpFormatter, argparse.ArgumentDefaultsHelpFormatter):
    pass


def timeit(function):
    '''
    用装饰器实现函数计时
    :param function: 需要计时的函数
    :return: None
    '''

    @wraps(function)
    def function_timer(*args, **kwargs):
        print('[Function: {name} start...]'.format(name=function.__name__))
        t0 = time.time()
        result = function(*args, **kwargs)
        t1 = time.time()
        print('[Function: {name} finished, spent time: {time:.2f}s]'.format(name=function.__name__, time=t1 - t0))
        return result
