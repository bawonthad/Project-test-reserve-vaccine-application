*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC05_ConfirmPayment
    Start Video Recording    name=Video/TC05_ConfirmPayment  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC05_ConfirmPayment.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${File}               Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},6).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page
            
            Input Text    txt_user    ${username}
            Input Text    txt_password    ${password}
            Click Element    Clicklogin
            Wait Until Element Is Visible    android:id/button1
            Click Element    android:id/button1
            Wait Until Element Is Visible    Viewall_card
            Click Element    Viewall_card
            Wait Until Element Is Visible    btn_payment
            Click Element    btn_payment
            Wait Until Element Is Visible    btn_choosefile
            IF  "${File}"!=""
                Click Element    btn_choosefile
                Wait Until Element Is Visible    //*[@text="951 KB-JPG.jpg"]
                File type    ${File}
            END
            
            Wait Until Element Is Visible    btn_saverecipt
            Click Element    btn_saverecipt

            Wait Until Element Is Visible    android:id/message
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    7    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    8    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    9    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC05_ConfirmPayment_Result/${TDID}_Fail.jpg
                Write Excel Cell    ${x}    7    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    8    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    9    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC05_ConfirmPayment_Result.xlsx
    Stop Video Recording

*** Keywords ***
File type
    [Arguments]    ${File}
    IF  "${File}"=="นามสกุลไฟล์เป็น .gif"
    Click Element    //*[@text="986 KB-GIF.gif"]

    ELSE IF    "${File}"=="ขนาดไฟล์รูปภาพเกิน 1 MB"
        Click Element    //*[@text="1.07 MB-JPG.jpg"]

    ELSE IF    "${File}"=="นามสกุลไฟล์เป็น .png"
        Click Element    //*[@text="964 KB-PNG.png"]

    ELSE IF    "${File}"=="นามสกุลไฟล์เป็น .jpg"
        Click Element    //*[@text="951 KB-JPG.jpg"]

    ELSE IF    "${File}"=="ขนาดไฟล์รูปภาพไม่เกิน 1 MB"
        Click Element    //*[@text="951 KB-JPG.jpg"]
    END
