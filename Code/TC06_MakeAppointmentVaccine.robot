*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC06_MakeAppointmentVaccine
    # Start Video Recording    name=Video/TC06_MakeAppointmentVaccine  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    TestData/TC06_MakeAppointmentVaccine.xlsx    doc_id=TestData
    ${excel}    Get Sheet    TestData
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}    Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${tdid}        Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${tdid}
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
            Click Element    android:id/button1
            Sleep    1s
            Click Element    Import_card
            Sleep    1s
            Click Element    button5
            Click Element    //*[@text="13"]
            Click Element    radioButton_time_1
            Click Element    btn_saveappointment
            Sleep    1s

            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    8    value=Pass    sheet_name=TestData
            ELSE
                Take Screenshot    Screenshot/${tdid}_Fail.png
                Write Excel Cell    ${x}    8    value=Fail    sheet_name=TestData
                Write Excel Cell    ${x}    9    value=${Real results}    sheet_name=TestData
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC06_MakeAppointmentVaccine_Result.xlsx
    # Stop Video Recording
