*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC02_Login
    Start Video Recording    name=Video/TC02_Login  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC02_Login.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}                 Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}               Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${TDID}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},5).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page

            Input Text    txt_user    ${Username}
            Input Text    txt_password    ${Password}
            Click Element    Clicklogin
            
            Wait Until Element Is Visible    android:id/message
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    6    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    7    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    8    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC02_Login_Result/${TDID}_Fail.jpg
                Write Excel Cell    ${x}    6    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    7    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    8    value=ควรแสดงข้อความแจ้งเตือนว่า "${Expected result}"    sheet_name=Test data
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC02_Login_Result.xlsx
    Stop Video Recording
