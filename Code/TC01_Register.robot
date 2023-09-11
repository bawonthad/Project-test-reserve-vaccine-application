*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary
Library    SelectDay.py

*** Variables ***
${CLICK_DATE}         xpath=(//android.widget.ImageView)[3]
${HEADER_YEAR}        id=android:id/date_picker_header_year
${HEADER_DATE}        id=android:id/date_picker_header_date
${OK_YEAR_BTN}        id=android:id/button1
${YEAR_LIST}          xpath=//android.widget.ListView/android.widget.TextView
${MONTH_AND_YEAR}     xpath=(//android.view.View/android.view.View)[1]
${PREV_BTN}           id=android:id/prev
${NEXT_BTN}           id=android:id/next
${DAY_LIST}           xpath=//android.view.View/android.view.View

*** Test Cases ***
TC01_Register
    Start Video Recording    name=Video/TC01_Register  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC01_Register.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${Status}" == "Y"
            ${TDID}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Name}                    Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Lastname}                Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${Address}                 Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${Phone}                   Set Variable If    "${excel.cell(${x},6).value}" == "None"    ${EMPTY}    ${excel.cell(${x},6).value}
            ${Gender}                  Set Variable If    "${excel.cell(${x},7).value}" == "None"    ${EMPTY}    ${excel.cell(${x},7).value}
            ${Email}                   Set Variable If    "${excel.cell(${x},8).value}" == "None"    ${EMPTY}    ${excel.cell(${x},8).value}
            ${ID card}                 Set Variable If    "${excel.cell(${x},9).value}" == "None"    ${EMPTY}    ${excel.cell(${x},9).value}
            ${Day}                     Set Variable If    "${excel.cell(${x},10).value}" == "None"    ${EMPTY}    ${excel.cell(${x},10).value}
            ${Expected result}         Set Variable       ${excel.cell(${x},11).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page

            Click Element    textView21
            Wait Until Element Is Visible    input_name
            Input Text    input_name    ${Name}
            Input Text    input_lastname    ${Lastname}
            Input Text    input_address    ${Address}
            Input Text    input_phone    ${Phone} 

            Swipe By Percent    50    70    50    20    1000

            IF    "${gender}" == "ชาย"
                Click Element    radio_Male
            ELSE IF    "${gender}" == "หญิง"
                Click Element    radio_Female
            END

            Input Text    input_email    ${Email}
            Input Text    input_idcard    ${ID card}
            Click Element    input_brithday
            IF    "${Day}"=="เลือกปี (ปีปัจจุบัน -11)"
                ${Day}=    minus11years
            ELSE IF    "${Day}"=="เลือกปี (ปีปัจจุบัน -12)"
                ${Day}=    minus12years
            ELSE IF    "${Day}"=="เลือกปี (ปีปัจจุบัน -13)"
                ${Day}=    minus13years
            END
            Select day    ${Day}
            
            Wait Until Element Is Visible    bt_register
            Click Element    bt_register

            Wait Until Element Is Visible    android:id/message
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    12    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    13    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    14    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    15    value=No error    sheet_name=Test data
                Write Excel Cell    ${x}    16    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC01_Register_Result/${TDID}_Fail.jpg
                Write Excel Cell    ${x}    12    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    13    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    14    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    15    value=Error    sheet_name=Test data
                Write Excel Cell    ${x}    16    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
            END
            Close Application
        END
    END
    Save Excel Document    Results/Excel/TC01_Register_Result.xlsx
    Stop Video Recording

*** Keywords *** 
Select day
    [Arguments]    ${date_come_in}
    Wait Until Element Is Visible    ${HEADER_YEAR}
    ${CURR_YEAR}    Get Text    ${HEADER_YEAR}
    ${CURR_DATE}    Get Text    ${HEADER_DATE}
    Click Element    ${HEADER_YEAR}
    ${DATE_TARGET_ARRAY}=    Split Str By Slash    ${date_come_in}
    ${TARGET_DAY}=    Set Variable    ${DATE_TARGET_ARRAY}[0]
    ${TARGET_MONTH}=    Set Variable    ${DATE_TARGET_ARRAY}[1]
    ${TARGET_YEAR}=    Set Variable    ${DATE_TARGET_ARRAY}[2]

    FOR    ${j}  IN RANGE    100
                ${elements}    Get Webelements    ${YEAR_LIST}
                ${flag}    Set Variable    20
                ${str}    Set Variable    20
                FOR    ${elem}    IN    @{elements}
                    ${str}=    Get Text    ${elem}
                    IF    ${str} == ${TARGET_YEAR}
                        Click Element    ${elem}
                        ${flag}    Set Variable    ${str}
                        Exit For Loop
                    END
                END
                Exit For Loop If    ${str} == ${flag}
                ${FIRST_ELEM}=    Set Variable    ${elements}[0]
                ${TEXT_OF_FIRST}=    Get Text    ${FIRST_ELEM} 
                IF    ${TEXT_OF_FIRST} < ${TARGET_YEAR}
                    Swipe By Percent    50    65    50    35    1000
                ELSE IF    ${TEXT_OF_FIRST} > ${TARGET_YEAR}
                    Swipe By Percent    50    35    50    65    1000
                END
            END

            FOR  ${i}  IN RANGE    100
                ${content_desc}=    Get Element Attribute    ${MONTH_AND_YEAR}    content-desc
                ${res_content_desc}=    Split Month And Date    ${content_desc}
                ${date}=    Set Variable    ${res_content_desc}[0]
                ${month}=    Set Variable    ${res_content_desc}[1]
                ${num_month}=    Convert Month To Number    ${month}
                ${INT_TARGET_MONTH}=    Str To Int    ${TARGET_MONTH}
                IF    ${num_month} > ${INT_TARGET_MONTH}
                    Click Element    ${PREV_BTN}
                ELSE IF    ${num_month} < ${INT_TARGET_MONTH}
                    Click Element    ${NEXT_BTN}
                ELSE
                    ${days}    Get Webelements    ${DAY_LIST}
                    FOR    ${day}    IN    @{days}
                        ${day_content_desc}=    Get Element Attribute    ${day}    content-desc
                        ${day_content_desc_arr}=    Split Str By Space    ${day_content_desc}
                        ${real_day}=    Set Variable    ${day_content_desc_arr}[0]
                        ${num_day}=    Str To Int    ${real_day}
                        ${TARGET_DAY_INT}=    Str To Int    ${TARGET_DAY}
                        IF    ${num_day} == ${TARGET_DAY_INT}
                            Click Element    ${day}
                            Exit For Loop
                        END
                    END
                    Exit For Loop
                END
            END

            Wait Until Element Is Visible    ${OK_YEAR_BTN}
            Click Element    ${OK_YEAR_BTN}
            Sleep    1s
