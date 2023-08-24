*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC10_SearchReservationMember
    # Start Video Recording    name=Video/TC10_SearchReservationMember  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    TestData/TC10_SearchReservationMember.xlsx    doc_id=TestData
    ${excel}    Get Sheet    TestData
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${tdid}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${tdid}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${ID card}            Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},6).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page

            Input Text    txt_user    ${username}
            Input Text    txt_password    ${password}
            Click Element    Clicklogin
            Sleep    1s
            Click Element    android:id/button1
            Sleep    1s
            Click Element    Search_card
            Sleep    1s
            Input Text    tv_idcard    ${ID card}
            Click Element    button_search
            Sleep    1s
            
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    7    value=Pass    sheet_name=TestData
            ELSE
                Take Screenshot    Screenshot/${tdid}_Fail.png
                Write Excel Cell    ${x}    7    value=Fail    sheet_name=TestData
                Write Excel Cell    ${x}    8    value=${Real results}    sheet_name=TestData
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC10_SearchReservationMember_Result.xlsx
    # Stop Video Recording
