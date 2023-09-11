*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC06_MakeAppointmentVaccine
    Start Video Recording    name=Video/TC06_MakeAppointmentVaccine  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC06_MakeAppointmentVaccine.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Username}         Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}         Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${Date}             Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${Time}             Set Variable If    "${excel.cell(${x},6).value}" == "None"   ${EMPTY}    ${excel.cell(${x},6).value}
            ${Expected result}  Set Variable       ${excel.cell(${x},7).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page
            
            Input Text    txt_user    ${Username}
            Input Text    txt_password    ${Password}
            Click Element    Clicklogin
            Wait Until Element Is Visible    android:id/button1    1m
            Click Element    android:id/button1
            Wait Until Element Is Visible    Import_card    1m
            Click Element    Import_card
            Wait Until Element Is Visible    button5    1m
            Click Element    button5

            Wait Until Element Is Visible    xpath=//*[@text="15"]    1m
            IF  "${Date}"=="เลือกวันที่เป็นช่องสีขาว"
                Click Element    //*[@text="9"]
            ELSE IF    "${Date}"=="เลือกวันที่เป็นช่องสีแดง"
                Click Element    //*[@text="11"]
            ELSE IF    "${Date}"=="เลือกวันที่เป็นช่องสีเขียวแต่เป็นวันในอดีต"
                Click Element    //*[@text="6"]
            ELSE IF    "${Date}"=="เลือกวันที่เป็นช่องสีเขียวแต่เป็นวันปัจจุบัน"
                Click Element    //*[@text="7"]
            ELSE IF    "${Date}"=="เลือกวันที่เป็นช่องสีเขียวและเป็นวันในอนาคต"
                Click Element    //*[@text="8"]

                Wait Until Element Is Visible    radioButton_time_1    1m
                IF  "${Time}"=="1"
                    Click Element    radioButton_time_1
                ELSE IF    "${Time}"=="2"
                    Click Element    radioButton_time_2
                ELSE IF    "${Time}"=="3"
                    Click Element    radioButton_time_3
                ELSE IF    "${Time}"=="4"
                    Click Element    radioButton_time_4
                ELSE IF    "${Time}"=="5"
                    Click Element    radioButton_time_5
                END
                Click Element    btn_saveappointment
            END

            Write excel    ${x}    ${TDID}    ${Expected result}
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC06_MakeAppointmentVaccine_Result.xlsx
    Stop Video Recording

*** Keywords ***
Write excel
    [Arguments]    ${x}    ${TDID}    ${Expected result}
    Sleep    1s
    ${element_visible} =    Run Keyword And Return Status    Element Should Be Visible    android:id/message
    
    IF  ${element_visible}
        ${Real results}=    Get Text    android:id/message
        IF    "${Real results}" == "${Expected result}"
            Write Excel Cell    ${x}    8    value=${Real results}    sheet_name=Test data
            Write Excel Cell    ${x}    9    value=Pass    sheet_name=Test data
            Write Excel Cell    ${x}    10    value=Pass    sheet_name=Test data
            Write Excel Cell    ${x}    11    value=No error    sheet_name=Test data
            Write Excel Cell    ${x}    12    value=-    sheet_name=Test data
        ELSE
            Take Screenshot    Screenshot/TC06_MakeAppointmentVaccine_Result/${TDID}_Fail.jpg
            Write Excel Cell    ${x}    8    value=${Real results}    sheet_name=Test data
            Write Excel Cell    ${x}    9    value=Fail    sheet_name=Test data
            Write Excel Cell    ${x}    10    value=Fail    sheet_name=Test data
            Write Excel Cell    ${x}    11    value=Error    sheet_name=Test data
            Write Excel Cell    ${x}    12    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
        END
    ELSE
        Take Screenshot    Screenshot/TC06_MakeAppointmentVaccine_Result/${TDID}_Fail.jpg
        Write Excel Cell    ${x}    8    value=ไม่แสดงข้อความแจ้งเตือน    sheet_name=Test data
        Write Excel Cell    ${x}    9    value=Fail    sheet_name=Test data
        Write Excel Cell    ${x}    10    value=Fail    sheet_name=Test data
        Write Excel Cell    ${x}    11    value=Error    sheet_name=Test data
        Write Excel Cell    ${x}    12    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
    END
