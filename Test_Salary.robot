*** Settings ***
Library          REST
Library          SeleniumLibrary
Library          OperatingSystem
Library          Collections
Library          Dialogs
Suite Setup      Set Selenium Speed    0.1 seconds
Test Teardown    Close All Browsers

*** Variables ***
${url}           http://test.blockfint.com/
${salary_url}    https://slack-redir.net/link?url=http%3A%2F%2Ftest.blockfint.com%2Fsalary.json
${browser}       chrome

*** Keywords ***
#ฝากเงินให้ครบจำนวนครั้งใน 1 คน และตรวจสอบความถูกต้องของยอด
For Loop Deposit
    [Arguments]    ${list}    ${i}
    FOR    ${j}    IN RANGE    3
        Element Should Be Visible   xpath=//*[@id="deposit"]/div/div[4]/div[2]/input
        Element Should Be Visible   xpath=//*[@id="deposit"]/div/div[3]/div[2]
        Element Should Be Visible   name=login-button
        ${log}                      Get Text        xpath=//*[@id="deposit"]/div/div[3]/div[2]
        ${log}                      Set Variable    ${log}
        Input Text                  xpath=//*[@id="deposit"]/div/div[4]/div[2]/input    ${list}[${i}][${j}]
        Click Element               name=login-button
        Wait Until Page Contains    จำนวนเงิน
        Element Should Be Visible   xpath=//*[@id="deposit"]/div/div[3]/div[2]
        ${log_deposit}              Get Text        xpath=//*[@id="deposit"]/div/div[3]/div[2]
        ${log_deposit}              Set Variable    ${log_deposit}
        ${deposit}                  Evaluate        ${log_deposit}-${log}
        Run Keyword If              ${deposit}!=${list}[${i}][${j}]       Execute Manual Step      ยอดเงินหลัง deposit เป็นยอดเงินที่ไม่ถูกต้อง
    END

*** Test Cases ***
Test Deposit
    #นำค่าจาก url และทำการสร้างไฟล์
    GET                  ${salary_url}
    Output               response body            employee.json
    ${employee_json}     Get File                 employee.json 
    ${employees_data}    Evaluate                 json.loads('''${employee_json}''')    
    ${employee}          Set Variable             ${employees_data['lists']}
    

    #สร้าง dictionary ระหว่าง id กับ salary
    ${id_salary}       Create Dictionary
    ${len_employee}    Get Length               ${employee}

    FOR    ${i}    IN RANGE    ${len_employee}
        ${id}                Get From Dictionary       ${employee}[${i}]        id
        ${salary}            Get From Dictionary       ${employee}[${i}]        salary
        Set To Dictionary    ${id_salary}              ${id}                    ${salary}
    END
    

    #เรียงลำดับเงินเดือนจากมากไปน้อย จากนั้นนำ id ของ 3 คน ที่มีเงินเดือนมากที่สุดไปเก็บไว้ใน list
    ${sort_salary}    Evaluate        sorted(${id_salary}.items(), key=lambda item : item[1], reverse = True)
    ${id_top_list}    Create List

    FOR    ${l}    IN RANGE    3
        Append To List    ${id_top_list}    ${sort_salary}[${l}][0]
    END

    #แสดง id ของคนที่มีเงินเดือนสูงที่สุด 3 คน
    Log To Console    id ของคนที่มีเงินเดือนสูงที่สุด 3 คน : ${id_top_list}
    

    #สร้าง dictionary ระหว่าง id กับ Deposit
    ${id_deposit}    Create Dictionary

    FOR    ${a}    IN RANGE    ${len_employee}
        ${id}                Get From Dictionary        ${employee}[${a}]          id
        ${deposit}           Get From Dictionary        ${employee}[${a}]          Deposit
        Set To Dictionary    ${id_deposit}              ${id}                      ${deposit}
    END


    #สร้าง list เก็บยอดฝากเงินของ 3 คนที่มีเงินเดือนมากที่สุด
    ${deposit_list}    Create List

    FOR    ${id}    IN RANGE    3
        Append To List    ${deposit_list}    ${id_deposit}[${id_top_list}[${id}]]
    END
    
    
    #ทำการฝากเงินในระบบ
    Open Browser    http://test.blockfint.com    ${browser}
    Wait Until Page Contains     เงินฝาก
    Maximize Browser Window
    FOR    ${id}    IN RANGE    3
        Element Should Be Visible    name=id
        Element Should Be Visible    name=login-button
        Input Text                   name=id               ${id_top_list}[${id}]
        Click Button                 name=login-button
        Wait Until Page Contains     จำนวนเงิน
        For Loop Deposit             ${deposit_list}       ${id}
        Element Should Be Visible    xpath=//*[@id="w1"]/li/a
        Click Element                xpath=//*[@id="w1"]/li/a
    END