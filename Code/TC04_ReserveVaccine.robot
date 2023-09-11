*** Settings ***
Library    AppiumLibrary
Library    ExcelLibrary
Library    ScreenCapLibrary

*** Test Cases ***
TC04_ReserveVaccine
    Start Video Recording    name=Video/TC04_ReserveVaccine  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document    Test data/TC04_ReserveVaccine.xlsx    doc_id=Test data
    ${excel}    Get Sheet    Test data
    FOR    ${x}    IN RANGE    2    ${excel.max_row+1}
        ${status}                 Set Variable If    "${excel.cell(${x},2).value}" == "None"    ${EMPTY}    ${excel.cell(${x},2).value}
        IF    "${status}" == "Y"
            ${TDID}               Set Variable If    "${excel.cell(${x},1).value}" == "None"    ${EMPTY}    ${excel.cell(${x},1).value}    
            Log To Console   Testing is ${tdid}
            ${Username}           Set Variable If    "${excel.cell(${x},3).value}" == "None"    ${EMPTY}    ${excel.cell(${x},3).value}
            ${Password}           Set Variable If    "${excel.cell(${x},4).value}" == "None"    ${EMPTY}    ${excel.cell(${x},4).value}
            ${Vaccine name}       Set Variable If    "${excel.cell(${x},5).value}" == "None"    ${EMPTY}    ${excel.cell(${x},5).value}
            ${Amount}             Set Variable If    "${excel.cell(${x},6).value}" == "None"    ${EMPTY}    ${excel.cell(${x},6).value}
            ${Confirm order}      Set Variable If    "${excel.cell(${x},7).value}" == "None"    ${EMPTY}    ${excel.cell(${x},7).value}
            ${Expected result}    Set Variable       ${excel.cell(${x},8).value}

            Open Application  http://localhost:4723/wd/hub    
            ...    platformName=Android  
            ...    platformVersion=%{ANDROID_PLATFORM_VERSION=9}
            ...    appPackage=th.ac.mju.itsci.reservevaccine_project
            ...    appActivity=.Login_page
            
            Input Text    txt_user    ${username}
            Input Text    txt_password    ${password}
            Click Element    Clicklogin
            Wait Until Element Is Visible    android:id/button1    20s
            Click Element    android:id/button1
            Wait Until Element Is Visible    Add_card    10s
            Click Element    Add_card

            Wait Until Element Is Visible    select_VaccineList_item    10s
            Click Element    select_VaccineList_item
            Sleep    1s
            IF  "${Vaccine name}"=="Moderna"
                Click Element    //android.widget.TextView[1]
            ELSE IF    "${Vaccine name}"=="Sinovac"
                Click Element    //android.widget.TextView[2]
            END
            
            Click Element    spn_no
            Sleep    1s
            IF  "${Amount}"=="1"
                Click Element    //android.widget.TextView[1]
            ELSE IF    "${Amount}"=="2"
                Click Element    //android.widget.TextView[2]
            END
            
            Wait Until Element Is Visible    checkBox5
            IF  "${Confirm order}"=="Checked"
                Click Element    checkBox5
            END
            Click Element    btn_add_reserve
            
            Wait Until Element Is Visible   android:id/message    10s
            ${Real results}=    Get Text    android:id/message
            IF    "${Real results}" == "${Expected result}"
                Write Excel Cell    ${x}    9    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    10    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    11    value=Pass    sheet_name=Test data
                Write Excel Cell    ${x}    12    value=No error    sheet_name=Test data
                Write Excel Cell    ${x}    13    value=-    sheet_name=Test data
            ELSE
                Take Screenshot    Screenshot/TC04_ReserveVaccine_Result/${TDID}_Fail.png
                Write Excel Cell    ${x}    9    value=${Real results}    sheet_name=Test data
                Write Excel Cell    ${x}    10    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    11    value=Fail    sheet_name=Test data
                Write Excel Cell    ${x}    12    value=Error    sheet_name=Test data
                Write Excel Cell    ${x}    13    value=${Real results}    sheet_name=Test data
            END
            Close Application
        END
    END
    
    Save Excel Document    Results/Excel/TC04_ReserveVaccine_Result.xlsx
    Stop Video Recording
