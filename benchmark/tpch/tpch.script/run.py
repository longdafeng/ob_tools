#!/usr/bin/env python
# __CR__
# Copyright (c) 2020 - 2021 xxxxxx  Corporation
# All Rights Reserved
#
# This software contains the intellectual property of fastsql  Corporation
# or is licensed to fastsql  Corporation from third parties.  Use of this
# software and the intellectual property contained therein is expressly
# limited to the terms and conditions of the License Agreement under which
# it is provided by or on behalf of fastsql .
# __CR__
#
# Author(s): Longda hustjackie@gmail.com
#


"""
Module to run tpch
"""

########################      header       ####################
import os
import sys
import socket
import re
import logging
import commands
import getopt
import datetime
import time
import string
import pdb
import fcntl
import traceback
import time
from subprocess import Popen, PIPE

########################## global   data     begin ###########################
STATUS_OK = 0
STATUS_ERR = -1

log = None

CFG_MAP = {}

CFG_KEY = "cfg"
LOG_KEY = "log"

HOST_KEY = "host"
PORT_KEY = "port"
USR_KEY = "username"
PWD_KEY = "password"
DB_KEY = "database"

INPUT_DIR_KEY = "input_dir"
OUTPUT_DIR_KEY = "output_dir"
MYSQL_SETTING_KEY = "mysql_setting"
TIMES_PER_SQL_KEY = "times_per_sql"
START_TIME_KEY = "StartTime"
SUM_SECONDS_KEY = "TotalSeconds"

PROG_NAME = None


def ReadFile(file):
    """
    Read file
    """
    try:
        if file[0] == '~':
            homedir = os.getenv("HOME")
            file = homedir + file[1:]
        f = open(file, 'r')
        contents = f.readlines()

    except Exception, ex:
        print ("Failed to open file %s" % file)
        return ""
    f.close()
    return contents


def WriteResult(file, data):
    """
    :param file: output file name
    :param data:
    :return:
    """
    try:
        f = open(file, 'w+')
        f.write(data)

    except Exception, ex:
        print ("Failed to open file %s" % file)
        return STATUS_ERR
    f.close()
    return STATUS_OK


def IsBlank(string):
    if string == None or len(string) == 0:
        return True
    else:
        return False


def RoundUp(digital):
    return round(digital * 100) / 100.0


def GetKeyValue(string):
    """
    Get key value frome string
    """
    try:
        re_kv = re.compile("\".+\".?:.?\".+\"")
        kv_search = None
        kv_search = re_kv.search(string)
        if kv_search == None:
            return (STATUS_ERR, "", "")
        kv_string = kv_search.group()
        key_start = kv_string.find("\"")
        if key_start < 0:
            print ("Failed to parse key %s" % string)
            return (STATUS_ERR, "", "")
        key_end = kv_string.find("\"", key_start + 1)
        if key_end < 0:
            print ("Failed to parse key %s" % string)
            return (STATUS_ERR, "", "")
        value_start = kv_string.find("\"", key_end + 1)
        if value_start < 0:
            print ("Failed to parse value %s" % string)
            return (STATUS_ERR, "", "")
        value_end = kv_string.find("\"", value_start + 1)
        if value_end < 0:
            print ("Failed to parse value %s" % string)
            return (STATUS_ERR, "", "")

        key = kv_string[key_start + 1: key_end]
        value = kv_string[value_start + 1: value_end]

        key = key.strip()
        value = value.strip()

    except Exception, ex:
        print ("Failed to parse %s" % string)
        return (STATUS_ERR, "", "")

    return (STATUS_OK, key, value)


def SetGlobalCfg(key, value):
    """
    Set global Parameter
    """
    global CFG_MAP
    CFG_MAP[key] = value


def ParseCfg(cfg):
    """
    Parse Configuration file to get input parameters
    """
    contents = ReadFile(cfg)
    if len(contents) == 0:
        return STATUS_ERR

    #The configuration comply with JSON schema
    #But We simplify the decode course
    for line in contents:
        line = line.strip()
        if len(line) == 0 or (line[0] == '/' and line[1] == '/'):
            continue
        (rc, key, value) = GetKeyValue(line)
        if rc:
            continue
        SetGlobalCfg(key, value)

    #cfgKeys = CFG_MAP.keys()
    return STATUS_OK


def Usage(prog):
    """
    prog
    """
    print("%s scan dir, if the file's modify time is less than current time interval seconds" % prog)
    print(" then move the file to the target dir")
    print(" %s [optional]" % prog)
    print(" optional parameters as following:")
    print("    -f --config   define the configuration file name")
    print("                  if not set, read %s.cfg" % prog)
    print("for example:")
    print("\t%s -f a.cfg" % prog)
    print("\t%s " % prog)


def ParseParm():
    """
    Parse Input parameter
    """
    global PROG_NAME
    PROG_NAME = sys.argv[0]
    index = PROG_NAME.find(".py")
    if index > 0:
        PROG_NAME = PROG_NAME[:index]
    prog = PROG_NAME
    args = sys.argv[1:]

    try:
        params = ["config", "help", "debug"]
        opts, args = getopt.getopt(args, "f:hD", params)
    except getopt.GetoptError, msg:
        Usage(prog)
        return (STATUS_ERR)

    debug = False
    help = False
    cfg = ""

    for opt, arg in opts:
        if opt in ("-f", "--config"):
            cfg = arg
        elif opt in ("-D", "--debug"):
            debug = True
            pdb.set_trace()
        elif opt in ("-h", "--help"):
            help = True
        else:
            help = True

    if help:
        Usage(prog)
        return STATUS_ERR

    if len(cfg) == 0:
        cfg = prog + ".cfg"
    SetGlobalCfg(CFG_KEY, cfg)

    return STATUS_OK


def CheckCfg():
    """
    Check the configuration is invalid or not
    :return:
    """
    host = CFG_MAP.get(HOST_KEY)
    if IsBlank(host):
        print("%s hasn't been set!" % HOST_KEY)
        return STATUS_ERR

    port = CFG_MAP.get(PORT_KEY)
    if IsBlank(port):
        print("%s hasn't been set!" % PORT_KEY)
        port = "3306"
        SetGlobalCfg(PORT_KEY, port)

    user = CFG_MAP.get(USR_KEY)
    if IsBlank(user):
        print("%s hasn't been set!" % USR_KEY)
        return STATUS_ERR

    password = CFG_MAP.get(PWD_KEY)
    if IsBlank(password):
        print("%s hasn't been set!" % PWD_KEY)
        return STATUS_ERR

    db = CFG_MAP.get(DB_KEY)
    if IsBlank(db):
        print("%s hasn't been set!" % DB_KEY)
        return STATUS_ERR

    inputDir = CFG_MAP.get(INPUT_DIR_KEY)
    if IsBlank(inputDir):
        print("%s hasn't been set!" % INPUT_DIR_KEY)
        return STATUS_ERR

    if os.path.exists(inputDir) == False:
        print("%s doesn't exist, no input source!" % inputDir)
        return STATUS_ERR

    if os.path.isdir(inputDir) == False:
        print("% isn't a directory!" % inputDir)
        return STATUS_ERR

    if len(os.listdir(inputDir)) == 0:
        print("% is a empty diretory!" % inputDir)
        return STATUS_ERR

    outputDir = CFG_MAP.get(OUTPUT_DIR_KEY)
    if inputDir == outputDir:
        outputDir = outputDir + "_result"
    if IsBlank(outputDir):
        print("%s hasn't been set!" % OUTPUT_DIR_KEY)
        return STATUS_ERR

    if os.path.exists(outputDir) == True and os.path.isdir(outputDir) == False:
        print("%s isn't a directory!" % outputDir)
        return STATUS_ERR

    if os.path.exists(outputDir) == False:
        os.mkdir(outputDir)

    LOG_FILE = CFG_MAP.get(LOG_KEY)
    if IsBlank(LOG_FILE):
        print("%s hasn't been set!" % LOG_KEY)
        LOG_FILE = outputDir + os.sep + PROG_NAME + ".log"
        SetGlobalCfg(LOG_KEY, LOG_FILE)

    timesPerSql = CFG_MAP.get(TIMES_PER_SQL_KEY)
    if IsBlank(timesPerSql) or timesPerSql <= 0:
        timesPerSql = 1
        SetGlobalCfg(TIMES_PER_SQL_KEY, timesPerSql)

    return STATUS_OK


def InitLog():
    """
    Init log operation
    """
    global log

    try:

        LOG_FILE = CFG_MAP[LOG_KEY]

        log = logging.getLogger(PROG_NAME)
        # set log level at logger level
        log.setLevel(logging.INFO)

        # create console handler
        consoleHandler = logging.StreamHandler()
        consoleHandler.setLevel(logging.INFO)

        # create file handler
        fileHandler = logging.FileHandler(LOG_FILE)
        fileHandler.setLevel(logging.INFO)

        # create formatter
        format = "%(asctime)s %(levelname)s %(filename)s:%(lineno)d %(message)s"
        formatter = logging.Formatter(format)
        consoleHandler.setFormatter(formatter)
        fileHandler.setFormatter(formatter)

        # add console & file handler
        log.addHandler(consoleHandler)
        log.addHandler(fileHandler)

        log.info("Successfully init log")
    except Exception, ex:
        print ("Failed to init log %s" % LOG_FILE)
        print (ex)
        return STATUS_ERR

    return STATUS_OK


def OutputResult(resultMap):
    """
    Dump the result to result file
    :param resultMap:
    :return:
    """

    startTime = resultMap[START_TIME_KEY]
    sum = resultMap[SUM_SECONDS_KEY]

    title = START_TIME_KEY + "," + SUM_SECONDS_KEY
    line = startTime + "," + sum

    resultMap.pop(START_TIME_KEY)
    resultMap.pop(SUM_SECONDS_KEY)

    for i in range(1, 23):
        key = str(i) + ".sql"
        value = resultMap.get(key)
        if IsBlank(value) == False:
            title = title + "," + key
            line = line + "," + value
            resultMap.pop(key)
        else:
            title = title + "," + key
            line = line + ",0.0"

    for (key, value) in resultMap.items():
        title = title + "," + key
        line = line + "," + value

    outputData = title + "\n" + line + "\n"
    resultFile = CFG_MAP[OUTPUT_DIR_KEY] + os.sep + "result.csv"
    isFileExist = os.path.exists(resultFile)
    if isFileExist == True:
        oldData = ReadFile(resultFile)
        if len(oldData) != 0:
        	outputData = "".join(oldData) + line + "\n"

    return WriteResult(resultFile, outputData)


def Run():
    """
    Run command
    """

    status, output = commands.getstatusoutput("mysql --version")
    log.info("%s %s" % (status, output))

    totalSeconds = 0
    resultMap = {}
    resultMap[START_TIME_KEY] = time.strftime(
        '%Y-%m-%d %H:%M:%S', time.localtime(time.time()))

    timesPerSQL = int(CFG_MAP[TIMES_PER_SQL_KEY])

    cmd = "mysql -h" + CFG_MAP[HOST_KEY] + " -P" + CFG_MAP[PORT_KEY] \
        + " -u" + CFG_MAP[USR_KEY] + " -p'" + \
            CFG_MAP[PWD_KEY] + "' -D" + CFG_MAP[DB_KEY] + " -e\""

    setCmd = cmd
    if IsBlank(CFG_MAP.get(MYSQL_SETTING_KEY)) == False:
        setCmd = cmd + CFG_MAP[MYSQL_SETTING_KEY] + ";"
        log.info("We will set session varaiable %s" % (setCmd))
    cmd = setCmd + "source "

    inputDir = CFG_MAP[INPUT_DIR_KEY]
    files = os.listdir(inputDir)
    scan_files = []
    for i in range(1, 23):
        key = str(i) + ".sql"
        if key in files:
            scan_files.append(key)
            files.remove(key)
    if len(files) > 0:
        files.sort()
        scan_files = scan_files + files

    log.info("We are going to run %s" % scan_files)
    for file in scan_files:
        sqlTime = 0
        minSqlTime = 0
        queryCmd = cmd + inputDir + os.sep + file + ";\""
        runTimes = timesPerSQL
        for i in range(timesPerSQL):
            isSuccess = False
            for j in range(3):
                log.info("Begin to query %s %d" % (file, i))
                startTime = time.time()
                status, output = commands.getstatusoutput(queryCmd)
                endTime = time.time()
                log.info("%s result :%s, output:\n %s" %(queryCmd, status, output))
                if status == 0:
                    costTime = endTime - startTime
                    sqlTime = sqlTime + costTime
                    isSuccess = True
                    if minSqlTime == 0:
                        minSqlTime = costTime
                    elif minSqlTime > costTime:
                        minSqlTime = costTime
                    break
                else:
                    log.info("We will retry one more time for %s %s" % (file, j))
            if isSuccess == False and runTimes > 1:
                runTimes -= 1

        avgTime = RoundUp(minSqlTime)
        log.info("%s result :%d, cost:\n %s" % (queryCmd, status, avgTime))
        totalSeconds = totalSeconds + avgTime
        resultMap[file] = str(avgTime)

    resultMap[SUM_SECONDS_KEY] = str(totalSeconds)
    return OutputResult(resultMap)


def Init():
    """
    Init program
    """
    cfg = CFG_MAP[CFG_KEY]
    rc = ParseCfg(cfg)
    if rc :
        print("Failed to parse configuration file %s" %cfg)
        return STATUS_ERR

    rc = CheckCfg()
    if  rc :
        print("Invalid configuration setting!")
        return STATUS_ERR

    rc = InitLog()
    if rc:
        print("Failed to init log")
        return STATUS_ERR

    log.info("Successfully do init job")
    return STATUS_OK

def Cleanup(status):
    """
    Do cleanup job
    """

    if status:
        if log == None:
            print("Failed to run %s " %(PROG_NAME))
        else:
            log.error("Failed to run %s " %PROG_NAME)
    else:
        if log == None:
            print("Successfully run %s" %PROG_NAME)
        else:
            log.info("Successfully run %s" %PROG_NAME)

def main():
    """
    main function
    """
    try:
        status = STATUS_ERR
        status = ParseParm()
        if status:
            Cleanup(status)
            return status
        
        status = STATUS_ERR
        status = Init()
        if status:
            Cleanup(status)
            return status

        status = STATUS_ERR
        status = Run()
        if status:
            Cleanup(status)
            return status

        
    except Exception , msg:
        Cleanup(status)
        print (msg)
        log.error("Exception:\n%s" %traceback.format_exc())
        return status
    
    Cleanup(STATUS_OK)
    return STATUS_OK

if __name__ == '__main__' :
    status = main()
    sys.exit(status)
