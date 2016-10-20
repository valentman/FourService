# This Python file uses the following encoding: utf-8
import optparse
import os
import sys
import getpass
import json
import hashlib
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.header import Header
from datetime import date, time, datetime, timedelta

commendPath = os.path.expanduser('~') + '/Documents/GitCode/'

#证书名
#发布证书
# certificateName = "iPhone Distribution: Chengdu Chelifang technology co., LTD (C9JJ87FG85)"
#开发证书
certificateName = "iPhone Developer: jian peng (P7ATKGF6ZW)"

#工程名
targetName = "FourService"
#主路径
mainPath = commendPath + targetName

#钥匙链相关
keychainPath="~/Library/Keychains/login.keychain"
keychainPassword="123"


#clean工程   
def cleanPro():
    os.system('cd %s;xcodebuild -target %s clean'%(mainPath,targetName))
    return

#清理pbxproj文件
def clearPbxproj():
    global all_the_text
    path = "%s/%s.xcodeproj/project.pbxproj"%(mainPath,targetName)
    file_object = open(path)
    try:
        all_the_text=file_object.readlines()
        for text in all_the_text:
            if 'PROVISIONING_PROFILE' in text:
                all_the_text.remove(text)
    finally:
        file_object.close()
       
    file_object = open(path,'w')
    try:
        for text in all_the_text:
            file_object.write(text)
    finally:
        file_object.close()
    return

#对文件夹授权
def allowFinder():
    os.system("chmod -R 777 %s"%mainPath)
    return

def allowKeychain():
    # User interaction is not allowed
    os.system("security unlock-keychain -p '%s' %s"%(keychainPassword,keychainPath))
    return

#查找文件
def scan_files(directory,postfix):
  files_list=[]
  for root, sub_dirs, files in os.walk(directory):
    for special_file in sub_dirs:
        if special_file.endswith(postfix):
            files_list.append(os.path.join(root,special_file))    
  return files_list
  

#编译获取.app文件和dsym
def buildApp():
    files_list=scan_files(mainPath,postfix=".xcodeproj")
    temp = -1
    for k in range(len(files_list)):
        if files_list[k] == mainPath + "/" + targetName + ".xcodeproj":
            temp = k
    if temp >= 0:
        files_list.pop(temp)
    for target in files_list:
        target=target.replace(".xcodeproj","")
        tmpList=target.split('/')
        name=tmpList[len(tmpList)-1]
        path=target.replace(name,"")
        path=path[0:len(path)-1]
        os.system("cd %s;xcodebuild -target %s CODE_SIGN_IDENTITY='%s'"%(path,name,certificateName))
    os.system("cd %s;xcodebuild -target %s CODE_SIGN_IDENTITY='%s'"%(mainPath,targetName,certificateName))
    return

#创建ipa
def cerateIPA():
    os.system ("cd %s; rm -r -f %s.ipa"%(mainPath,targetName))
    os.system ("xcrun -sdk iphoneos PackageApplication -v %s/build/Release-iphoneos/%s.app -o %s/%s.ipa CODE_SIGN_IDENTITY='%s'"%(mainPath,targetName,mainPath,targetName,certificateName))
    return

#上传
def uploadToFir():
    httpAddress = None
    if os.path.exists("%s/%s.ipa"%(mainPath,targetName)):
        os.system("open ./")
        # ret = os.popen("fir p '%s/%s.ipa' -T '%s'"%(mainPath,targetName,firToken))
        # for info in ret.readlines():
        #     if "Published succeed" in info:
        #         httpAddress = info
        #         print httpAddress
        #         break
    else:
        print "没有找到ipa文件"
    return httpAddress

#主函数
def main():
	#设置文件夹权限
    # allowFinder()
    # allowKeychain()
    # #clear pbxproj文件
    clearPbxproj()
    # #clean工程
    cleanPro()
	#编译
    buildApp()
    #生成ipa文件
    # cerateIPA()
    # os.system("open ./")

main()