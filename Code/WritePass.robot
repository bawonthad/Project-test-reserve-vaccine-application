*** Settings ***
Library    ExcelLibrary

*** Test Cases ***
WritePass
    Open Excel Document    Results/Excel/TC10_SearchReservationMember_Result.xlsx    doc_id=Test data
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
                ${Actual result}    Set Variable       ${excel.cell(${x},8).value}



                # ${formatted_text}   Evaluate    "${Actual result}".replace(" ", "")    # ใช้ฟังก์ชัน replace() เพื่อลบช่องว่างทั้งหมด
                # Should Be Equal As Strings    ${formatted_text}    A A A

                IF  "${Actual result}"=="ไม่พบข้อมูลการจองของสมาชิก"
                    Write Excel Cell    ${x}    10    value=Pass    sheet_name=Test data
                    Write Excel Cell    ${x}    11    value=No error    sheet_name=Test data
                END
            END
        END
        Save Excel Document    Results/Excel/TC10_SearchReservationMember_Result_2.xlsx