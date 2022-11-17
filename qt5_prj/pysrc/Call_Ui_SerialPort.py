#!/usr/bin/env python
# coding=utf-8
'''逻辑文件'''

import re
import sys
import binascii
import time
from PyQt5.QtCore import QTimer, QDateTime
from PyQt5.QtWidgets import *
from PyQt5.QtSerialPort import QSerialPort, QSerialPortInfo
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtCore import QDate
from Ui_serial_main import Ui_MainWindow

class MyMainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.StatusBarItems()
        self.CreateItems() # 设置实例
        self.CreateSignalSlot() #设置信号和槽

    def StatusBarItems(self):
        self.lenTxData = 0
        self.lenRxData = 0
        self.datalenLabel = QLabel()
        self.datalenLabel.setText(f"   Tx : {self.lenTxData}   |   Rx : {self.lenRxData}")
        self.statusBar.addPermanentWidget(self.datalenLabel,1)
        self.emptylabel = QLabel()
        self.statusBar.addPermanentWidget(self.emptylabel,4)
        self.statusBarShowTime()


    def showCurrentTime(self,timeLabel):
        curtime = QDateTime.currentDateTime()
        timeDisplay = curtime.toString('yyyy-MM-dd hh:mm:ss dddd')
        timeLabel.setText(timeDisplay)
        

    def statusBarShowTime(self):
        self.timer = QTimer()
        self.timeLabel = QLabel()
        self.statusBar.addPermanentWidget(self.timeLabel,1)
        self.timer.timeout.connect(lambda: self.showCurrentTime(self.timeLabel))
        self.timer.start(1000)

    def CreateItems(self):
        self.serial1 = QSerialPort() #Qt 串口类
        self.serial2 = QSerialPort()

    def CreateSignalSlot(self):
        self.pbt_open_1.clicked.connect(self.pbt_open_1_clicked)
        self.pbt_open_2.clicked.connect(self.pbt_open_2_clicked)
        self.pbt_send.clicked.connect(self.pbt_send_clicked)
        self.pbt_refresh_1.clicked.connect(self.pbt_refresh_1_clicked)
        self.pbt_refresh_2.clicked.connect(self.pbt_refresh_2_clicked)
        self.serial1.readyRead.connect(self.serial1_receive_data)
        self.checkBox_hex_send.stateChanged.connect(self.showhexsend)
        self.checkBox_hex_receive.stateChanged.connect(self.showhexreceive)
        self.pbt_clear_receive.clicked.connect(self.pbt_clear_clicked)
        self.serial2.readyRead.connect(self.serial2_rxtxdata)

    def pbt_clear_clicked(self):
        self.textEdit_Receive.clear()
        self.textEdit_serial2.clear()
        self.lenRxData = 0
        self.lenTxData = 0
        self.datalenLabel.setText(f"   Tx : {self.lenTxData}   |   Rx : {self.lenRxData}")

    def serial1_send_data(self):
        curtime = QDateTime.currentDateTime()
        timeDisplay = curtime.toString('hh:mm:ss.z')
        txData = self.lineEdit_Send.text()
        self.textEdit_Send.insertPlainText(f"{timeDisplay}:\n{txData}\n")
        if len(txData) == 0 :
            return
        if self.checkBox_hex_send.isChecked() == False:
            self.serial1.write(txData.encode('UTF-8'))
            self.lenTxData += len(txData.encode('UTF-8'))
        else:
            Data = txData.replace(' ','')
            if len(Data)%2 == 1:
                Data+='0'
            if Data.isalnum() is False:
                QMessageBox.critical(self,'错误','包含非十六进制数')
            try:
                hexData = binascii.a2b_hex(Data)
            except:
                QMessageBox.critical(self,'错误','转换编码错误')
                return
            try:
                self.serial1.write(hexData)
            except:
                QMessageBox.critical(self,'异常','十六进制发送错误')
                return
            self.lenTxData += len(Data)
        self.datalenLabel.setText(f"   Tx : {self.lenTxData}   |   Rx : {self.lenRxData}")

    
    def serial1_receive_data(self):
        curtime = QDateTime.currentDateTime()
        timeDisplay = curtime.toString('hh:mm:ss.z')
        try:
            rxData = bytes(self.serial1.readAll())
            '''串口数据转发 serial1 rx => serial2 tx'''
            if self.pbt_open_2.isChecked() == True:
                self.serial2.write(rxData)
        except:
            QMessageBox.critical(self,'错误','串口接收数据错误')
        if self.checkBox_hex_receive.isChecked() == False:
            try:
                rxToDisplay = f"{timeDisplay}:\n{rxData.decode('UTF-8')}\n"
                self.textEdit_Receive.insertPlainText(rxToDisplay)
                if self.pbt_open_2.isChecked() == True:
                    self.textEdit_serial2.insertPlainText(f"{timeDisplay}  tx :\n{rxData.decode('UTF-8')}\n")
                self.lenRxData += len(rxData)
            except:
                QMessageBox.critical(self,'接收区错误','UTF-8译码错误')
                pass
        else:
            Data = binascii.b2a_hex(rxData).decode('ascii')
            self.textEdit_Receive.insertPlainText(f"{timeDisplay}:\n{Data.upper()}\n")
            if self.pbt_open_2.isChecked() == True:
                self.textEdit_serial2.insertPlainText(f"{timeDisplay}  tx :\n{Data.upper()}\n")
            self.lenRxData += len(Data)
        self.datalenLabel.setText(f"   Tx : {self.lenTxData}   |   Rx : {self.lenRxData}")

    def serial2_rxtxdata(self):
        curtime = QDateTime.currentDateTime()
        timeDisplay = curtime.toString('hh:mm:ss.z')
        try:
            rxData = bytes(self.serial2.readAll())
        except:
            QMessageBox.critical(self,'错误','串口接收数据错误')
        if self.checkBox_hex_receive.isChecked() == False:
            try:
                rxToDisplay = f"{timeDisplay}  rx :\n{rxData.decode('UTF-8')}\n"
                self.textEdit_serial2.insertPlainText(rxToDisplay)
            except:
                QMessageBox.critical(self,'接收区错误','UTF-8译码错误')
        else:
            Data = binascii.b2a_hex(rxData).decode('ascii')
            self.textEdit_serial2.insertPlainText(f"{timeDisplay}  rx :\n{Data.upper()}\n")

    def pbt_refresh_1_clicked(self):
        self.serial1.clear()
        serial = QSerialPort()
        serial_list = QSerialPortInfo.availablePorts()
        for info in serial_list:
            serial.setPort(info)
            if serial.open(QSerialPort.ReadWrite):
                self.serial_1.addItem(info.portName())
                serial.close()

    def pbt_refresh_2_clicked(self):
        self.serial2.clear()
        serial = QSerialPort()
        serial_list = QSerialPortInfo.availablePorts()
        for info in serial_list:
            serial.setPort(info)
            if serial.open(QSerialPort.ReadWrite):
                self.serial_2.addItem(info.portName())
                serial.close()
            else:
                i = serial.error()
                QMessageBox.critical(self,'error',f'{i} readwrite faild') 

    def showhexreceive(self):
        if self.checkBox_hex_receive.isChecked() == True:
            #接受区换行
            pass
            
    def showhexsend(self):
        if self.checkBox_hex_send.isChecked() == True:
            pass

    def pbt_send_clicked(self):
        self.serial1_send_data()


    def pbt_open_1_clicked(self):
        if self.pbt_open_1.isChecked() == True:
            serial1Name = self.serial_1.currentText()
            serial1Baud = int(self.baudrate_1.currentText())
            self.serial1.setPortName(serial1Name)
            try:
                if self.serial1.open(QSerialPort.ReadWrite) == False:
                    QMessageBox.critical(self,'错误','串口readwrite失败')
                    return
            except:
                QMessageBox.critical(self,'错误','串口打开失败')
                return
            self.pbt_refresh_1.setEnabled(False)
            self.serial_1.setEnabled(False)
            self.baudrate_1.setEnabled(False)
            self.pbt_send.setEnabled(True)
            self.serial1.setBaudRate(serial1Baud)
            self.serial1_state.setText('已打开')
        else:
            self.serial1.close()
            self.pbt_refresh_1.setEnabled(True)
            self.serial_1.setEnabled(True)
            self.baudrate_1.setEnabled(True)
            self.pbt_send.setEnabled(False)
            self.serial1_state.setText('已关闭')

    def pbt_open_2_clicked(self):
        if self.pbt_open_2.isChecked() == True:
            serial2Name = self.serial_2.currentText()
            serial2Baud = int(self.baudrate_2.currentText())
            self.serial2.setPortName(serial2Name)
            try:
                if self.serial2.open(QSerialPort.ReadWrite) == False:
                    QMessageBox.critical(self,'错误','串口打开失败')
                    return
            except:
                QMessageBox.critical(self,'错误','串口打开失败')
                return
            self.pbt_refresh_2.setEnabled(False)
            self.serial_2.setEnabled(False)
            self.baudrate_2.setEnabled(False)
            self.serial2.setBaudRate(serial2Baud)
            self.serial2_state.setText('已打开')
        else:
            self.serial2.close()
            self.pbt_refresh_2.setEnabled(True)
            self.serial_2.setEnabled(True)
            self.baudrate_2.setEnabled(True)
            self.serial2_state.setText('已关闭')

if __name__ == "__main__":
    app = QApplication(sys.argv)
    myWin = MyMainWindow()
    myWin.show()
    sys.exit(app.exec())
