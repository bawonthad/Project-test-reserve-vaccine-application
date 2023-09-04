*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC10_SearchReservationMember
    Start Video Recording    name=Video/TC10_SearchReservationMember  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC10_SearchReservationMember.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${Booking type}       Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${ID card}            Set Variable If    "${excel.cell(${x},6).value}" == "None"    ${EMPTY}    ${excel.cell(${x},6).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},7).value}

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
            Wait Until Element Is Visible    Search_card
            Click Element    Search_card

            Wait Until Element Is Visible    spn_reserve_status
            Sleep    1s
            Click Element    spn_reserve_status

            Wait Until Element Is Visible    xpath=//android.widget.TextView[5]
            IF  "${Booking type}"=="รอยืนยันชำระเงิน"
                Click Element    xpath=//android.widget.TextView[1]
            ELSE IF    "${Booking type}"=="ชำระเงินเสร็จสิ้น"
                Click Element    xpath=//android.widget.TextView[2]
            ELSE IF    "${Booking type}"=="ยกเลิกการจอง"
                Click Element    xpath=//android.widget.TextView[3]
            ELSE IF    "${Booking type}"=="ทำการนัดหมายเรียบร้อยแล้ว"
                Click Element    xpath=//android.widget.TextView[4]
            ELSE IF    "${Booking type}"=="หมดเวลานัดหมาย"
                Click Element    xpath=//android.widget.TextView[5]
            END
            
            Input Text    tv_idcard    ${ID card}    
            Click Element    button_search
            
            IF  "${ID card}"=="1709800373243"
                Wait Until Element Is Visible    txt_status_list
                ${Real results}    Get Text    txt_status_list
            ELSE
                Wait Until Element Is Visible    android:id/message
                ${Real results}    Get Text    android:id/message
            END
            
            IF    "${Real results}" == "${Expected result}"
                    Write Excel Cell    ${x}    8    value=${Real results}    sheet_name=Test data
                    Write Excel Cell    ${x}    9    value=Pass    sheet_name=Test data
                    Write Excel Cell    ${x}    10    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC10_SearchReservationMember_Result/${TDID}_Fail.jpg
                Write Excel Cell    ${x}    8    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    9    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    10    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC10_SearchReservationMember_Result.xlsx
    Stop Video Recording
