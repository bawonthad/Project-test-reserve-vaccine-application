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
TC07_AddVaccine
    Start Video Recording    name=Video/TC07_AddVaccine  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC07_AddVaccine.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${VaccineName}        Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${DateInDay}          Set Variable If    "${excel.cell(${x},6).value}" == "None"    ${EMPTY}    ${excel.cell(${x},6).value}
            ${MgfDateDay}         Set Variable If    "${excel.cell(${x},7).value}" == "None"    ${EMPTY}    ${excel.cell(${x},7).value}
            ${ExpDateDay}         Set Variable If    "${excel.cell(${x},8).value}" == "None"    ${EMPTY}    ${excel.cell(${x},8).value}
            ${DoesQty}            Set Variable If    "${excel.cell(${x},9).value}" == "None"    ${EMPTY}    ${excel.cell(${x},9).value}
            ${VaccineCompanny}    Set Variable If    "${excel.cell(${x},10).value}" == "None"    ${EMPTY}    ${excel.cell(${x},10).value}
            ${ImportedCompanny}   Set Variable If    "${excel.cell(${x},11).value}" == "None"    ${EMPTY}    ${excel.cell(${x},11).value}
            ${ProductVersion}     Set Variable If    "${excel.cell(${x},12).value}" == "None"    ${EMPTY}    ${excel.cell(${x},12).value}
            ${RegisterNo}         Set Variable If    "${excel.cell(${x},13).value}" == "None"    ${EMPTY}    ${excel.cell(${x},13).value}
            ${DoesPrice}          Set Variable If    "${excel.cell(${x},14).value}" == "None"    ${EMPTY}    ${excel.cell(${x},14).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},15).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page

            Input Text    txt_user    ${username}
            Input Text    txt_password    ${password}
            Click Element    Clicklogin
            Wait Until Element Is Visible    android:id/button1    1m
            Click Element    android:id/button1
            Wait Until Element Is Visible    Add_card    1m
            Click Element    Add_card
            Wait Until Element Is Visible    txt_vcName    1m
            Input Text    txt_vcName     ${VaccineName}
            
            IF  "${DateInDay}"!=""
                Click Element    date_in
                Classify date    ${DateInDay}
            END
            
            IF  "${MgfDateDay}"!=""
                Click Element    mgf_date
                Classify date    ${MgfDateDay}
            END

            IF  "${ExpDateDay}"!=""
                Click Element    exp_date
                Classify date    ${ExpDateDay}
            END
            
            Input Text    edit_does    ${DoesQty}
            Input Text    manufacturing_company    ${VaccineCompanny}
            Swipe By Percent    50    60    50    20    1000
            Input Text    imported_company    ${ImportedCompanny}
            Input Text    edit_product_version    ${ProductVersion}
            Input Text    edit_register_no    ${RegisterNo}
            Input Text    edite_doesPrice    ${DoesPrice}
            Click Element    btn_addvaccine
            
            Wait Until Element Is Visible    android:id/message    1m
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    16    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    17    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    18    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    19    value=No error    sheet_name=Test data
                Write Excel Cell    ${x}    20    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC07_AddVaccine_Result/${TDID}_Fail.jpg
                Write Excel Cell    ${x}    16    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    17    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    18    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    19    value=Error    sheet_name=Test data
                Write Excel Cell    ${x}    20    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC07_AddVaccine_Result.xlsx
    Stop Video Recording

*** Keywords *** 
Select day
    [Arguments]    ${date_come_in}
    Wait Until Element Is Visible    ${HEADER_YEAR}    1m
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

            Wait Until Element Is Visible    ${OK_YEAR_BTN}    1m
            Click Element    ${OK_YEAR_BTN}
            Sleep    1s

Classify date
    [Arguments]    ${TypeDate}
    IF  "${TypeDate}"=="วันในอดีต"
        ${TypeDate}=    past_days
    ELSE IF    "${TypeDate}"=="วันปัจจุบัน"
        ${TypeDate}=    present_day
    ELSE IF    "${TypeDate}"=="วันในอนาคต"
        ${TypeDate}=    future_day
    ELSE IF    "${TypeDate}"=="วันปัจจุบันหรือวันในอดีต และเป็นวันที่มากกว่าวันที่ผลิต และน้อยกว่าวันที่หมดอายุ"
        ${TypeDate}=    present_day
    ELSE IF    "${TypeDate}"=="วันที่น้อยกว่าวันที่ผลิต"
        ${TypeDate}=    less_MgfDateDay
    ELSE IF    "${TypeDate}"=="วันที่มากกว่าวันที่หมดอายุ"
        ${TypeDate}=    more_ExpDateDay
    END
    Select day    ${TypeDate}
